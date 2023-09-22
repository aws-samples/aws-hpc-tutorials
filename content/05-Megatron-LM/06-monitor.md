---
title: "d. Monitor Job Status"
weight: 15
tags: ["tutorial", "cloud9", "ParallelCluster"]
---

In this section we'll monitor the status of the GPU's using the excellent tool [nvtop](https://github.com/Syllo/nvtop).

1. First grab the hostname of the running GPU from `squeue`, for example if the job is running on `p5-dy-cr-48xlarge-[1-10]` we'll use `p5-dy-cr-48xlarge-1`.

```bash
ubuntu@ip-10-0-21-245:~$ squeue
JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
    6        p5 megatron   ubuntu  R       0:22      1 p5-dy-cr-48xlarge-1
```

2. Next SSH into one of the instances and install `nvtop`:

```bash
ssh p5-dy-cr-48xlarge-1
sudo apt-get -y install nvtop
```

3. Now run `nvtop`:

![nvtop](/images/04-Megatron-LM/nvtop-2.png)