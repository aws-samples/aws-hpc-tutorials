#!/bin/bash
#SBATCH --exclusive
#SBATCH --wait-all-nodes=1
#SBATCH --gpus-per-node=8
#SBATCH --ntasks-per-gpu=1

# set -aex;
set -ex;
env | grep SLURM | sort


################################################################################
# 000. Configurable settings
################################################################################
: "${IMAGE:=/apps/bignlp-training_22.09-py3-bcp-nsys-2022.5.1-v2-efa.sqsh}"
: "${FSX_MOUNT:=/fsx:/fsx}"
: "${MODEL:=gpt3}"
: "${MODEL_SIZE:=5b}"


################################################################################
# 005. AWS settings
################################################################################
# Push these AWS env vars all the way down to all workers.
export FI_EFA_FORK_SAFE=1
export NCCL_DEBUG=INFO
export NCCL_PROTO=simple
export FI_LOG_LEVEL=1
export FI_EFA_ENABLE_SHM_TRANSFER=0
# Below env vars are already in our custom bignlp_training container
#export FI_EFA_USE_DEVICE_RDMA=1 # use for p4dn
#export FI_PROVIDER=efa
#export RDMAV_FORK_SAFE=1

declare -a CONTAINER_MOUNTS=(
    # Enable uverbs access to EFA on p4de.24xlarge
    /dev/infiniband/uverbs0:/dev/infiniband/uverbs0
    /dev/infiniband/uverbs1:/dev/infiniband/uverbs1
    /dev/infiniband/uverbs2:/dev/infiniband/uverbs2
    /dev/infiniband/uverbs3:/dev/infiniband/uverbs3
)

################################################################################
# 010. Generate submission.sh (ref: references/bignlp-training/main.sh).
################################################################################
SHARED_FS=${FSX_MOUNT#*:}  # Take <dst> from <src>:<dst>
BASE_RESULTS_DIR=$SHARED_FS/results/results-$SLURM_JOB_ID
CONT_TOKENIZER_DIR=$SHARED_FS/data/bpe
INDEX_MAPPING_DIR=$SHARED_FS/index_mapping_dir/$SLURM_JOB_ID
CONT_DATA_DIR=$SHARED_FS/data/the_pile_gpt3

# bignlp-scripts does not auto-mount index dir, so we need to tell it to do so.
CONTAINER_MOUNTS+=( $INDEX_MAPPING_DIR:$INDEX_MAPPING_DIR )

# Convert to csv
CONTAINER_MOUNTS_LIST=$(echo "${CONTAINER_MOUNTS[@]}" | tr ' ' ,)

declare -a SRUN_GEN_ARGS=(
    --nodes 1
    --ntasks-per-node 1
    --container-image $IMAGE

    # Must be able to write the generated artifacts to shared file-system.
    --container-mounts $BASE_RESULTS_DIR:$BASE_RESULTS_DIR
)

mkdir -p $BASE_RESULTS_DIR/ $INDEX_MAPPING_DIR/
/usr/bin/time srun "${SRUN_GEN_ARGS[@]}" bash -c "
echo 'Generating submission script...'
env | sort
set -ex

declare ARGS=(
    container_mounts=[$CONTAINER_MOUNTS_LIST]
    cluster_type=bcm
    ++cluster.stderr_to_stdout=True
    container=$IMAGE
    training=$MODEL/$MODEL_SIZE
    stages=[training]
    bignlp_path=/opt/bignlp/bignlp-scripts
    data_dir=$CONT_DATA_DIR
    base_results_dir=$BASE_RESULTS_DIR
    env_vars.NCCL_TOPO_FILE=/opt/bignlp/bignlp-scripts/tools/csp/aws/topo.xml
    env_vars.NCCL_DEBUG=$NCCL_DEBUG
    env_vars.NCCL_PROTO=$NCCL_PROTO
    cluster.srun_args=[--container-mount-home]

    # Not sure why these must be set in tandem for the right values to go through.
    training.trainer.num_nodes=$SLURM_JOB_NUM_NODES
    ++cluster.nodes=$SLURM_JOB_NUM_NODES

    training.trainer.enable_checkpointing=False
    training.exp_manager.resume_if_exists=False
    training.trainer.max_steps=5
    training.trainer.val_check_interval=5
    training.exp_manager.create_checkpoint_callback=False
    training.model.tokenizer.vocab_file=$CONT_TOKENIZER_DIR/vocab.json
    training.model.tokenizer.merge_file=$CONT_TOKENIZER_DIR/merges.txt
    training.model.data.index_mapping_dir=$INDEX_MAPPING_DIR
)

HYDRA_FULL_ERROR=1 BIGNLP_DEBUG=1 python3 /opt/bignlp/bignlp-scripts/main.py \${ARGS[@]}
"

SUBMISSION_SH=$BASE_RESULTS_DIR/${MODEL}_${MODEL_SIZE}/bignlp-${MODEL}_${MODEL_SIZE}_submission.sh

# Modify the submission.sh:
# - remove bignlp_path from container mount.
# - time the srun
# - remove SBATCH directives
sed -i \
    -e 's|--container-mounts /opt/bignlp/bignlp-scripts:/opt/bignlp/bignlp-scripts,|--container-mounts |g' \
    -e 's|^srun |/usr/bin/time srun |g' \
    -e 's|^#SBATCH .*||g' \
    $SUBMISSION_SH


################################################################################
# 020. Execute the submission.sh which invokes 'srun ...'
################################################################################
# Silent "srun: Job 88 step creation temporarily disabled, retrying (Requested nodes are busy)"
# See: https://bugs.schedmd.com/show_bug.cgi?id=119
sleep 10

# In case numa-mapping fails, we still want keep going on.
set +e

BEGIN_TRAINING=$(date)
source $SUBMISSION_SH
END_TRAINING=$(date)


################################################################################
# 030. Emit job information
################################################################################
echo BEGIN_TRAINING: $BEGIN_TRAINING
echo END_TRAINING: $END_TRAINING
scontrol show job $SLURM_JOB_ID || true
squeue -j $SLURM_JOB_ID || true
