---
title : "c. Examine an EFA enabled instance"
date: 2020-05-12T10:00:58Z
weight : 20
tags : ["tutorial", "EFA", "ec2", "fi_info", "mpi"]
---

In this section, you will learn how to check if EFA is enabled on your cluster. Make sure you're [connected to the cluster](/05-create-cluster/02-connect-cluster.html#ssm-connect) before proceeding.

#### EFA Enabled

To check if an instance supports EFA we can run the **fi_info -p efa** command, this command queries to see if the efa fabric interface is active. If we run this command on the master:

```bash
$ fi_info -p efa
fi_getinfo: -61
```

We'll see a "Not Found", indicated by the `-61` response. This is because the efa interface is not enabled on the master. In order to accelerate our jobs, we'll need to run on the compute instances. In the following sections we'll spin up a compute instance and examine it again with **fi_info**.

#### Allocate a Compute Node

First, you have to connect to a compute nodes. We'll use `salloc` to allocate an instance:

```bash
salloc -N 1
```

#### Check the Node status

Starting up a new node will take about 2 minutes. In the meantime you can check the status of the queue using the command **squeue**. The job will be first marked as creating (*CF* state) because resources are being created.
If you check the **Instances Tab** in pcluster manager you should see nodes booting up. When ready the nodes will be added automatically to your SLURM cluster and you will see a **R** running status as below.

```bash
watch squeue
```

```bash
JOBID PARTITION     NAME     USER     ST       TIME  NODES NODELIST(REASON)
   3   compute    interact   ec2-user  R       1:01      1 compute-dy-hpc6a-1
```

Hit **Ctrl-C** to exit `watch squeue`.

#### Check the Compute node status

You can also check the number of nodes available in your cluster using the command **sinfo**. Do not hesitate to refresh it, nodes generally take less than 2 mins to appear. The following example shows one node.

```bash
sinfo
```

```bash
PARTITION AVAIL  TIMELIMIT  NODES  STATE NODELIST
compute*     up   infinite     63  idle~ compute-dy-hpc6a-[2-64]
compute*     up   infinite      1    mix compute-dy-hpc6a-1
```


#### SSH Into the compute nodes from the Master

At this stage your compute nodes is ready and you can connect to it using **ssh**:

```bash
ssh compute-dy-hpc6a-1
```

#### Check EFA

Once you are in, you can use the **fi_info** tool to verify whether EFA is active. The tool also provides details about provider support, the available interfaces, as well to validate the libfabric installation:

```bash
fi_info -p efa
```

The output of **fi_info** should be similar to this below:

```bash
provider: efa
    fabric: EFA-fe80::4b4:caff:fe96:3ba0
    domain: rdmap0s6-rdm
    version: 113.20
    type: FI_EP_RDM
    protocol: FI_PROTO_EFA
provider: efa
    fabric: EFA-fe80::4b4:caff:fe96:3ba0
    domain: rdmap0s6-dgrm
    version: 113.20
    type: FI_EP_DGRAM
    protocol: FI_PROTO_EFA
```

Now you can disconnect from the compute node, just type **exit**.

```
exit
```

Make sure to cancel the job with `scancel [job_id]` so your compute node gets terminated:

```bash
$ squeue
JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
    3   compute interact ec2-user  R       4:14      1 compute-dy-hpc6a-1
$ scancel 3
salloc: Job allocation 3 has been revoked.
Hangup
```

Next, compile and install a simple HPC benchmark.
