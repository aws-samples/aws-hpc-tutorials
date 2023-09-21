---
title: "b. Fetch Dataset"
weight: 11
tags: ["tutorial", "cloud9", "ParallelCluster"]
---

We'll be using the [oscar-1GB.jsonl](https://huggingface.co/bigscience/misc-test-data/resolve/main/stas/oscar-1GB.jsonl.xz) dataset along with [gpt2-vocab.json](https://s3.amazonaws.com/models.huggingface.co/bert/gpt2-vocab.json) and [gpt2-merges.txt](https://s3.amazonaws.com/models.huggingface.co/bert/gpt2-merges.txt) files from Hugging Face. 

1. Download the data onto the shared FSx Lustre drive in the cluster:

```bash
cd /fsx
mkdir -p /fsx/data/ && cd data/

wget https://huggingface.co/bigscience/misc-test-data/resolve/main/stas/oscar-1GB.jsonl.xz
wget https://s3.amazonaws.com/models.huggingface.co/bert/gpt2-vocab.json
wget https://s3.amazonaws.com/models.huggingface.co/bert/gpt2-merges.txt
xz -d oscar-1GB.jsonl.xz
```