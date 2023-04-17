---
title : "c. Run PyTorch Data Parallel training on ParallelCluster with synthetic data"
date: 2020-09-04T15:58:58Z
weight : 30
tags : ["training", "data parallel", "ML", "sbatch", "slurm", "multi node", "multi gpu"]
---

In this step you will use the **PyTorch** _DistributedDataParallel API_ to start a simple training job on 2 nodes with sythetic data and simple deep learning model.
It assumes you have python and pytorch installed on the nodes. Users can use this as a test before running their workloads.

#### Create distributed training script and run the job
```bash
wget https://raw.githubusercontent.com/aws-samples/parallelcluster-efa-gpu-preflight-ami/main/preflight/run.py
wget https://raw.githubusercontent.com/aws-samples/parallelcluster-efa-gpu-preflight-ami/main/preflight/multi_node_ddp.sbatch
sbatch multi_node_ddp.sbatch
```

The last command will return job ID, tail the logs with `tail -f slurm-${JOB_ID}`. You should see the following in job log:
1. You should see `NCCL INFO NET/OFI Selected Provider is efa` in the logs to make sure EFA is choosen.
2. We use [torchrun](https://pytorch.org/docs/stable/elastic/run.html) to [launch](https://github.com/aws-samples/parallelcluster-efa-gpu-preflight-ami/blob/main/preflight/multi_node_ddp.sbatch#L14) training job ([TorchX](https://pytorch.org/torchx/latest/schedulers/slurm.html) is alternative). It will define [environmental variables](https://pytorch.org/docs/stable/elastic/run.html#environment-variables) that `torch.distributed` then uses to form a cluster of workers like `RANK` some of which are printed in logs and can be used to make sure cluster is formed - we have 2 nodes and each has 8 GPUs where we set `--nproc_per_node` to 1 which means each GPU will host 1 worker and we shoudl have 16 (2x8) ranks from 0 to 15.
3. You should see logs like `rank: 4, step: 800` which means that rank 4 just finished 800th training step.
