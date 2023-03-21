#!/bin/bash
#SBATCH --exclusive
#SBATCH --gres=gpu:8
#SBATCH --gpus-per-node=8
#SBATCH --wait-all-nodes=1

#set -aex;
set -ex;

################################################################################
# 000. Configurable settings
################################################################################
: "${IMAGE:=/apps/bignlp-training_22.09-py3-bcp-nsys-2022.5.1-v2-efa.sqsh}"
: "${RUN_SH:=/home/ec2-user/marcverd/nemo4aws/run.sh}"
: "${FSX_MOUNT:=/fsx:/fsx}"


################################################################################
# 010. Here we go...
################################################################################
env | grep SLURM | sort

export FI_EFA_USE_DEVICE_RDMA=1 # use for p4dn
export FI_EFA_FORK_SAFE=1
export NCCL_DEBUG=INFO
export NCCL_PROTO=simple
export FI_LOG_LEVEL=1
export FI_PROVIDER=efa
export FI_EFA_ENABLE_SHM_TRANSFER=0

export RDV_ADDR=$(hostname)
export WORLD_SIZE=$SLURM_JOB_NUM_NODES

declare -a ARGS=(
    --container-image $IMAGE
    --container-mounts /dev/infiniband/uverbs0:/dev/infiniband/uverbs0
    --container-mounts /dev/infiniband/uverbs1:/dev/infiniband/uverbs1
    --container-mounts /dev/infiniband/uverbs2:/dev/infiniband/uverbs2
    --container-mounts /dev/infiniband/uverbs3:/dev/infiniband/uverbs3
    --container-mount-home
    --container-mounts $FSX_MOUNT
)

BEGIN_TRAINING=$(date)
export SHARED_FS=${FSX_MOUNT#*:}  # Take <dst> from <src>:<dst> -- needed by run.sh.
/usr/bin/time srun "${ARGS[@]}" $RUN_SH
END_TRAINING=$(date)


################################################################################
# 030. Emit job information
################################################################################
echo BEGIN_TRAINING: $BEGIN_TRAINING
echo END_TRAINING: $END_TRAINING
scontrol show job $SLURM_JOB_ID || true
squeue -j $SLURM_JOB_ID || true
