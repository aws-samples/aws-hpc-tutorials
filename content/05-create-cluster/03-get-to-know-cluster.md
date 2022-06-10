---
title: "c. Get to know your Cluster"
weight: 53
tags: ["tutorial", "pcluster-manager", "ParallelCluster"]
---

Now that you are connected to the head node, familiarize yourself with the cluster structure by running the following set of commands.

## SLURM

![Slurm Logo](/images/pcluster/slurm.png)

{{% notice tip %}}
[SLURM](https://slurm.schedmd.com) from SchedMD is one of the batch schedulers that you can use in AWS ParallelCluster. For an overview of the SLURM commands, see the [SLURM Quick Start User Guide](https://slurm.schedmd.com/quickstart.html).
{{% /notice %}}

- **List existing partitions and nodes per partition**. Running `sinfo` shows both the instances we currently have running and those that are not running (think of this as a queue limit). Initially we'll see all the node in state `idle~`, this means no instances are running. When we submit a job we'll see some instances go into state `alloc` meaning they're currently completely allocated, or `mix` meaning some but not all cores are allocated. After the job completes the instance stays around for a few minutes ([default cooldown](https://docs.aws.amazon.com/parallelcluster/latest/ug/Scheduling-v3.html#yaml-Scheduling-SlurmSettings-ScaledownIdletime) is 10 mins) in state `idle%`. This can be confusing, so we've tried to simplify it in the below table:

| **State**   | **Description** |
| ----------- | ----------- |
| `idle~`     | Instance is not running but can launch when a job is submitted.                       | 
| `idle%`     | Instance is running and will shut down after [ScaledownIdletime](https://docs.aws.amazon.com/parallelcluster/latest/ug/Scheduling-v3.html#yaml-Scheduling-SlurmSettings-ScaledownIdletime) (default 10 mins).  |
| `mix`       | Instance is partially allocated.       |
| `alloc`     | Instance is completely allocated.        |

```bash
sinfo
```
- **List jobs in the queues or running**. Obviously, there won't be any since we did not submit anything...yet!
```bash
squeue
```

## Module Environment

[Environment Modules](http://modules.sourceforge.net/) are a fairly standard tool in HPC that is used to dynamically change your environment variables (`PATH`, `LD_LIBRARY_PATH`, etc).

- **List available modules** You'll notice that every cluster comes with `intelmpi` and `openmpi` pre-installed. These MPI versions are compiled with support for the high-speed interconnect [EFA](https://aws.amazon.com/hpc/efa/). 

```bash
module av
```

- **Load a particular module**. In this case, this command loads *IntelMPI* in your environment and checks the path of *mpirun*.
```bash
module load intelmpi
mpirun -V
```

## Shared Filesystems

- **List mounted NFS volumes**. A few volumes are shared by the head-node and will be mounted on compute instances when they boot up. Both */shared* and */home* are accessible by all nodes.

```bash
showmount -e localhost
```

- **List shared filesystems**. When we created the cluster, we also created a Lustre filesystem with [FSx Lustre](https://aws.amazon.com/fsx/lustre/). We can see where it was mounted and the storage size by running:

```bash
df -h
```

You'll see a line like:

```
172.31.21.202@tcp:/zm5lzbmv  1.1T  1.2G  1.1T   1% /shared
```

This is a **1.2 TB** filesystem, mounted at `/shared` that's **1%** used.

In the next section we'll install Spack on this shared filesystem!
