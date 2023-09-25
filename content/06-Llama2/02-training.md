---
title: "b. Submit a training job"
weight: 11
tags: ["tutorial", "cloud9", "ParallelCluster"]
---

1. Create a Slurm job script `submit-llama2.sh`

```bash
#!/bin/bash

# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

#SBATCH --nodes=2 # number of nodes to use, 24 p4d(e) = 192 A100 GPUs
#SBATCH --job-name=llama2 # name of your job
#SBATCH --gpus-per-node=8 # Number of GPU per node
#SBATCH --gres=gpu:8 # number of GPU we reserve
#SBATCH --exclusive # job has exclusive use of the resource, no sharing
#SBATCH --wait-all-nodes=1

set -ex;

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

# llama2 pretraining
module load openmpi
mpirun -n $SLURM_NTASKS -N $SLURM_JOB_NUM_NODES --map-by ppr:8:node --rank-by slot \
    --mca pml ^cm --mca btl tcp,self --mca btl_tcp_if_exclude lo,docker0 --bind-to none \
    /usr/bin/python3.10 -u training/llama/pretrain_mem.py \
        --model_name_or_path Llama-2-7b-hf \
        --data_path data.json \
        --bf16 True \
        --output_dir test\
        --num_train_epochs 2 \
        --per_device_train_batch_size 8 \
        --per_device_eval_batch_size 1 \
        --gradient_accumulation_steps 2 \
        --evaluation_strategy "no" \
        --save_strategy "steps" \
        --save_steps 250 \
        --learning_rate 1e-5 \
        --weight_decay 0.1 \
        --warmup_ratio 0.001 \
        --lr_scheduler_type "cosine" \
        --logging_steps 1 \
        --deepspeed training/utils/ds_config_zero3.json \
        --model_max_length 4096 \
        --gradient_checkpointing True
```

2. Submit the job:

    ```bash
    sbatch submit-llama2.sh
    watch squeue # wait for job to go into 'R' running
    ```

    You have to wait a couple of minutes for your compute instances to come up, once you see the job go from **PD** pending to **R** running state, you know the instances are up. Type **Ctrl-C** to exit squeue at any point.