#!/bin/bash

: "${MODEL_NAME:=gpt3}"
: "${MODEL_SIZE:=126m}"
: "${MAX_STEPS:=1000}"

: "${SHARED_FS:=/fsx}"

: "${CONT_TOKENIZER_DIR:=$SHARED_FS/data/bpe}"
: "${INDEX_MAPPING_DIR:=$SHARED_FS/index_mapping_dir}"
: "${CONT_RESULT_DIR:=$SHARED_FS/results}"
: "${CONT_DATA_DIR:=$SHARED_FS/data/the_pile_gpt3}"

: "${SLURM_JOB_ID:=asdf}"
: "${SLURM_GPUS_PER_NODE:=1}"
: "${WORLD_SIZE:=1}"
: "${RDV_ADDR:=localhost}"

env | sort

torchrun \
   --nproc_per_node=$SLURM_GPUS_PER_NODE \
   --nnodes=$WORLD_SIZE \
   --rdzv_id=$SLURM_JOB_ID \
   --rdzv_backend=c10d \
   --rdzv_endpoint=$RDV_ADDR \
   --no_python bash -c "cd /opt/bignlp/NeMo;
git rev-parse HEAD;
export PYTHONPATH=/opt/bignlp/NeMo:$PYTHONPATH;
sed -i 's/training\.//g' /opt/bignlp/bignlp-scripts/conf/training/$MODEL_NAME/$MODEL_SIZE.yaml;
set -x ;
sed -i 's|\${data_dir}|$CONT_DATA_DIR|g' /opt/bignlp/bignlp-scripts/conf/training/$MODEL_NAME/$MODEL_SIZE.yaml ;
HYDRA_FULL_ERROR=1 python3 -u /opt/bignlp/NeMo/examples/nlp/language_modeling/megatron_gpt_pretraining.py  \
--config-path=/opt/bignlp/bignlp-scripts/conf/training/$MODEL_NAME \
--config-name=$MODEL_SIZE.yaml \
run.results_dir=$CONT_RESULT_DIR/results-$SLURM_JOB_ID/${MODEL_NAME}_${MODEL_SIZE} \
exp_manager.explicit_log_dir=$CONT_RESULT_DIR/results-$SLURM_JOB_ID/${MODEL_NAME}_${MODEL_SIZE}/results \
trainer.num_nodes=$WORLD_SIZE \
trainer.enable_checkpointing=False \
exp_manager.resume_if_exists=False \
trainer.max_steps=$MAX_STEPS \
trainer.val_check_interval=$MAX_STEPS \
exp_manager.create_checkpoint_callback=False \
model.tokenizer.vocab_file=$CONT_TOKENIZER_DIR/vocab.json \
model.tokenizer.merge_file=$CONT_TOKENIZER_DIR/merges.txt \
model.data.index_mapping_dir=$INDEX_MAPPING_DIR/job-$SLURM_JOB_ID \
$ADDITIONAL_OPTS
"

#  model.data.data_prefix='[.0333,$CONT_DATA_DIR/my-gpt3_00_text_document]'
