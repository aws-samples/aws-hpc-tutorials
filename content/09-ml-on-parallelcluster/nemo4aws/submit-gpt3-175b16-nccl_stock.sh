#!/bin/bash

################################################################################
# 000. Configurable hyperparameters
################################################################################
# Needed by .sbatch file
export IMAGE=/apps/bignlp-training_22.09-py3-bcp-nsys-2022.5.1-v2-efa.sqsh
export JOB_SUFFIX=-nccl_stock
export NODES=16

# Needed by run.sh
export MODEL_SIZE=175b
export MAX_STEPS=40


################################################################################
# 010. Use as-is, but advance users are welcomed to make modifications.
################################################################################
: "${JOB_NAME:=gpt3-${MODEL_SIZE}${NODES}${JOB_SUFFIX}}"
export RUN_SH=$(dirname `readlink -e ${BASH_SOURCE[0]}`)/run.sh
echo Submitting $JOB_NAME ...
sbatch --nodes=$NODES --job-name=$JOB_NAME nemo-megatron.sbatch
