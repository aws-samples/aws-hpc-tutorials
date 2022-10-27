+++
title = "i. Get to know your Cluster"
date = 2022-04-10T10:46:30-04:00
weight = 90
tags = ["tutorial", "create", "ParallelCluster"]
+++

Now that you are connected to the head node, familiarize yourself with the cluster structure by running the following set of commands.

#### Slurm

{{% notice tip %}}
[Slurm](https://slurm.schedmd.com) from SchedMD is one of the batch schedulers that you can use in AWS ParallelCluster. For an overview of the Slurm commands, see the [Slurm Quick Start User Guide](https://slurm.schedmd.com/quickstart.html).
{{% /notice %}}

- **List existing partitions and nodes per partition**. You should see two nodes if your run this command after creating your cluster, and zero nodes if running it 10 minutes after creation (default cooldown period for AWS ParallelCluster, you don't pay for what you don't use).
```bash
sinfo
```
- **List jobs in the queues or running**. Obviously, there won't be any since we did not submit anything...yet!
```bash
squeue
```

#### Module Environment

[Lmod](https://lmod.readthedocs.io/en/latest/) is a fairly standard tool in HPC that is used to dynamically change your environment (env vars, PATH).

- **List available modules**
```bash
module av
```
- **Load a particular module**. In this case, this command loads IntelMPI in your environment and checks the path of *mpirun*.
```bash
module load intelmpi
which mpirun
```

#### NFS Shares

- **List mounted volumes**. A few volumes are shared by the head-node and will be mounted on compute instances when they boot up. Both */shared* and */home* are accessible by all nodes.
```bash
showmount -e localhost
```

Next, you can run your first job!
