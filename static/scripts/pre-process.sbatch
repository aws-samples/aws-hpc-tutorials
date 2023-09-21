#!/bin/bash
#SBATCH -N 1
#SBATCH --exclusive

# cd MegatronLoader
# docker build -t megatronloader .
# .sqsh file produced by enroot import -o /admin/ubuntu/megatron-lm/megatronloader.sqsh  dockerd://megatronloader:latest
: "${IMAGE:=/admin/ubuntu/megatron-lm/megatronloader.sqsh}"
: "${FSX_MOUNT:=/admin:/admin}"

declare -a ARGS=(
    --container-image $IMAGE
    --container-mount-home
    --container-mounts $FSX_MOUNT
)

# runs in

srun -l "${ARGS[@]}"  python3 ${PWD}/Megatron-LM//tools/preprocess_data.py \
        --input ${PWD}/data/oscar-1GB.jsonl \
        --output-prefix ${PWD}/data/my-gpt2 \
        --vocab-file ${PWD}/data/gpt2-vocab.json \
        --dataset-impl mmap \
        --tokenizer-type GPT2BPETokenizer \
        --merge-file ${PWD}/data/gpt2-merges.txt \
        --append-eod \
        --chunk-size 25 \
        --workers 8