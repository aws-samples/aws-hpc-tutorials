+++
title = "e. Log in to Your Cluster"
date = 2019-09-18T10:46:30-04:00
weight = 80
tags = ["tutorial", "create", "ParallelCluster"]
+++

{{% notice tip %}}
The **pcluster ssh** is a wrapper around SSH. Depending on the case, you can also log in to your head node using ssh and the public or private IP address.
{{% /notice %}}

You can list existing clusters using the following command. This is a convenient way to find the name of a cluster in case you forget it.

```bash
pcluster list --color
```

Now that your cluster has been created, log in to the head node using the following command in your AWS Cloud9 terminal:

```bash
pcluster ssh hpclab-yourname -i ~/.ssh/pc-intro-key
```

The EC2 instance asks for confirmation of the ssh login the first time you log in to the instance. Type **yes**.
![SSH cluster](/images/hpc-aws-parallelcluster-workshop/ec2-ssh-connect.png)

#### Getting to Know your Cluster

Now that you are connected to the head node, familiarize yourself with the cluster structure by running the following set of commands.

##### SLURM

{{% notice tip %}}
[SLURM](https://slurm.schedmd.com) from SchedMD is one of the batch schedulers that you can use in AWS ParallelCluster. For an overview of the SLURM commands, see the [SLURM Quick Start User Guide](https://slurm.schedmd.com/quickstart.html).
{{% /notice %}}

- **List existing partitions and nodes per partition**. You should see two nodes if your run this command after creating your cluster, and zero nodes if running it 10 minutes after creation (default cooldown period for AWS ParallelCluster, you don't pay for what you don't use).
```bash
sinfo
```
- **List jobs in the queues or running**. Obviously, there won't be any since we did not submit anything...yet!
```bash
squeue
```

##### Module Environment

[Lmod](https://lmod.readthedocs.io/en/latest/) is a fairly standard tool used to dynamically change your environment.

- **List available modules**
```bash
module av
```
- **Load a particular module**. In this case, this command loads IntelMPI in your environment and checks the path of *mpirun*.
```bash
module load intelmpi
which mpirun
```

##### NFS Shares

- **List mounted volumes**. A few volumes are shared by the head-node and will be mounted on compute instances when they boot up. Both */shared* and */home* are accessible by all nodes.
```bash
showmount -e localhost
```

Next, you can run your first job!
