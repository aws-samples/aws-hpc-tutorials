---
title: "c. Submit Training Job"
weight: 14
tags: ["tutorial", "cloud9", "ParallelCluster"]
---

In the following example we submit a Slurm script that runs the training workload across 24 instances, or 192 GPU's. It's ok to run on fewer instances, just adjust model size so you don't run out of memory.

In addition we set the following EFA flags:

| Environment Variable        | Value         | Description            |
|-----------------------------|---------------|:-----------------------:|
|  FI_EFA_USE_DEVICE_RDMA     |  `1`          | This enables GPU to GPU RDMA read and write (on H100).                             |
|  FI_EFA_FORK_SAFE           |  `1`          | See https://github.com/ofiwg/libfabric/issues/6332#issuecomment-834822754          |
|  FI_LOG_LEVEL               |  `1`          | Increase log level, useful for seeing if using EFA provider in libfabric.          |
|  FI_PROVIDER                |  `efa`        | Use EFA interface in Libfabric.                                                    |
|  FI_EFA_ENABLE_SHM_TRANSFER |  `1`          | Enable SHM provider to provide the communication across all intra-node processes. SHM transfer will be disabled in the case where ptrace protection is turned on. You can turn it off to enable shm transfer.               |
|  NCCL_ASYNC_ERROR_HANDLING  |  `1`          | See https://github.com/pytorch/elastic/issues/136               |
|  NCCL_DEBUG                 |  `INFO`       | Print out useful debugging information from NCCL.                                  |
|  CUDA_DEVICE_MAX_CONNECTIONS | `1`          | See https://github.com/NVIDIA/Megatron-LM/blob/main/megatron/arguments.py#L330     |

Flags **not** to use. If you see these set, please remove them:

| Environment Variable        | Value         | Description                |
|-----------------------------|---------------|:--------------------------:|
|  NCCL_ALGO                  |  `Ring`       | This is autodetected.      |
|  NCCL_PROTO                 |  `simple`     | This is also autodetected. |


1. Create a job submission script

```bash
#!/bin/bash

# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

#SBATCH --nodes=24 # number of nodes to use, 24 p4d(e) = 192 A100 GPUs
#SBATCH --job-name=megatron_gpt # name of your job
#SBATCH --gpus-per-node=8 # Number of GPU per node
#SBATCH --gres=gpu:8 # number of GPU we reserve
#SBATCH --exclusive # job has exclusive use of the resource, no sharing
#SBATCH --wait-all-nodes=1
#SBATCH --export=NIL # do not export env vars from the host env

set -ex;

###########################
###### User Variables #####
###########################

# Parallelism decomposition variables
: "${TENSOR_PARALLEL:=8}"
: "${PIPELINE_PARALLEL:=4}"

# Model parameters, defaults to 39B model
# Refer to page 8 of this paper on how to tune models parameters
# https://arxiv.org/pdf/2104.04473.pdf
: "${NUM_LAYERS:=36}"
: "${HIDDEN_SIZE:=4096}"
: "${NUM_ATTENTION_HEADS:=32}"
: "${SEQ_LENGTH:=2048}"
: "${MAX_POSITION_EMBEDDINGS:=2048}"
: "${MICRO_BATCH_SIZE:=1}"
: "${GLOBAL_BATCH_SIZE:=288}"

# default variables for Enroot
: "${APPS_PATH:=/apps}"
: "${DATA_PATH:=/fsx}"

# default variables for Enroot
: "${IMAGE:=$APPS_PATH/megatron-training.sqsh}"
: "${FSX_MOUNT:=$DATA_PATH:$DATA_PATH}"

###########################
## Environment Variables ##
###########################

## Plenty of EFA level variables
export FI_EFA_USE_DEVICE_RDMA=1 # use for p4d
export FI_EFA_FORK_SAFE=1
# export NCCL_ALGO=Ring
export FI_LOG_LEVEL=1
export FI_PROVIDER=efa # change to eth if you want to use ENA for comparisons
export FI_EFA_ENABLE_SHM_TRANSFER=1
# https://discuss.pytorch.org/t/nccl-network-is-unreachable-connection-refused-when-initializing-ddp/137352
# https://github.com/pytorch/pytorch/issues/68893
#export NCCL_SOCKET_IFNAME=ens
export NCCL_ASYNC_ERROR_HANDLING=1
export NCCL_DEBUG=INFO

# async runtime error ...
export CUDA_DEVICE_MAX_CONNECTIONS=1

#########################
## Command and Options ##
#########################

declare -a ARGS=(
    --container-image $IMAGE
    --container-mounts $FSX_MOUNT
)

declare -a TORCHRUN_ARGS=(
    --nproc_per_node=$SLURM_GPUS_PER_NODE \
    --nnodes=$SLURM_JOB_NUM_NODES \
    --rdzv_id=$SLURM_JOB_ID \
    --rdzv_backend=c10d \
    --rdzv_endpoint=$(hostname):29501 \
)

declare -a MEGATRON_ARGS=(
        --num-layers $NUM_LAYERS \
        --hidden-size $HIDDEN_SIZE \
        --num-attention-heads $NUM_ATTENTION_HEADS \
        --seq-length $SEQ_LENGTH \
        --max-position-embeddings $MAX_POSITION_EMBEDDINGS \
        --micro-batch-size $MICRO_BATCH_SIZE \
        --global-batch-size $GLOBAL_BATCH_SIZE \
)

declare -a MEGATRON_PARALLELISM=(
        --tensor-model-parallel-size $TENSOR_PARALLEL \
        --pipeline-model-parallel-size $PIPELINE_PARALLEL \
)

srun -l "${ARGS[@]}" python -m torch.distributed.run "${TORCHRUN_ARGS[@]}" /workspace/Megatron-LM/pretrain_gpt.py \
        "${MEGATRON_PARALLELISM[@]}" \
        "${MEGATRON_ARGS[@]}" \
        --train-samples 146484375 \
        --lr-decay-samples 126953125 \
        --lr-warmup-samples 183105 \
        --lr 6.0e-5 \
        --min-lr 6.0e-6 \
        --lr-decay-style cosine \
        --log-interval 1 \
        --eval-iters 40 \
        --eval-interval 1000 \
        --data-path "${DATA_PATH}/my-gpt2_text_document" \
        --vocab-file "${DATA_PATH}/gpt2-vocab.json" \
        --merge-file "${DATA_PATH}/gpt2-merges.txt" \
        --split 98,2,0 \
        --clip-grad 1.0 \
        --weight-decay 0.1 \
        --adam-beta1 0.9 \
        --adam-beta2 0.95 \
        --init-method-std 0.006 \
        --fp16 \
        --recompute-activations
```

2. Submit the job

    ```bash
    sbatch megatron-lm.sh
    watch squeue # wait for job to go into 'R' running
    ```

    You have to wait a couple of minutes for your compute instances to come up, once you see the job go from **PD** pending to **R** running state, you know the instances are up. Type **Ctrl-C** to exit squeue at any point.