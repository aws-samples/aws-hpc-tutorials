---
title: "b. Data Preprocessing"
weight: 12
tags: ["tutorial", "cloud9", "ParallelCluster"]
---

In this step we'll pre-process the "loose" json format into a cached index format we can use for training.

1. First create a dockerfile `data-preprocess.Dockerfile`:

```docker
FROM nvcr.io/nvidia/pytorch:23.01-py3
RUN apt update -y && apt install wget xz-utils git -y
RUN apt install python3 python3-pip -y
RUN cd /tmp && git clone https://github.com/bigscience-workshop/Megatron-DeepSpeed.git && cd Megatron-DeepSpeed && pip3 install -r requirements.txt

WORKDIR /tmp/Megatron-Deepspeed
```

2. Build the docker image:

```bash
docker build -t data-preprocess -f preprocess.Dockerfile .
```

3. Convert that into an enroot image:

```
enroot import -o /fsx/data-preprocess.sqsh  dockerd://data-preprocess:latest
```

2. Next create a Slurm submit script `preprocess.sbatch` to run the `preprocess_data.py` python script:

```bash
#!/bin/bash
#SBATCH -N 1
#SBATCH --exclusive


# docker build -t data-preprocess .
# .sqsh file produced by enroot import -o /admin/ubuntu/megatron-lm/megatronloader.sqsh  dockerd://megatronloader:latest
: "${IMAGE:=/fsx/data-preprocess.sqsh}"
: "${FSX_MOUNT:=/fsx:/fsx}"

declare -a ARGS=(
    --container-image $IMAGE
    --container-mount-home
    --container-mounts $FSX_MOUNT
)

# runs on a single node, 8 gpus
srun -l "${ARGS[@]}"  python3 ${PWD}/Megatron-LM/tools/preprocess_data.py \
        --input ${PWD}/data/oscar-1GB.jsonl \
        --output-prefix ${PWD}/data/my-gpt2 \
        --vocab-file ${PWD}/data/gpt2-vocab.json \
        --dataset-impl mmap \
        --tokenizer-type GPT2BPETokenizer \
        --merge-file ${PWD}/data/gpt2-merges.txt \
        --append-eod \
        --chunk-size 25 \
        --workers 8
```

3. Next submit the job to the queue:

```bash
sbatch pre-process.sh
```

{{% notice warning %}}
You must run this preprocessing script as Slurm job since it requires GPU acceleration. If you run the dockerfile directly it'll fail since the HeadNode is CPU only.
{{% /notice %}}
