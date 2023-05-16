+++
title = "i. Get to know your Cluster"
date = 2023-04-10T10:46:30-04:00
weight = 90
tags = ["tutorial", "create", "ParallelCluster"]
+++

Now that you are connected to the head node, familiarize yourself with the cluster structure by running the following set of commands. If you are connected using DCV, please open a Terminal window using the icon on the left:

![Open Terminal](/images/hpc-aws-parallelcluster-workshop/lab1-pcluster-workshop-10-DCV-terminal.png)

### SLURM

![Slurm Logo](/images/hpc-aws-parallelcluster-workshop/slurm.png)

{{% notice info %}}
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

- **Load a particular module**. In this case, this command loads *IntelMPI* in your environment and checks the path of *mpirun*. First, check to see what version of `mpirun` is available just to see the effect of the module load:

```bash
mpirun -V
```

The Intel MPI library can then be loaded, and the command rerun to see the loaded library:

```bash
module load intelmpi
mpirun -V
```

### Shared Filesystems

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
/dev/nvme1n1     50G   24K   47G   1% /shared
```

This is the shared [EBS filesystem](https://aws.amazon.com/ebs/), mounted at `/shared`.

In the next section the input files to run a job using the cluster will be copied.