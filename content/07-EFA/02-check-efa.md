---
title : "Examine an EFA enabled instance"
pre: "<b>c ⁃ </b>"
date: 2020-05-12T10:00:58Z
weight : 20
tags : ["tutorial", "EFA", "ec2", "fi_info", "mpi"]
---

In this section, you will learn how to check if EFA is enabled on your instance.

#### EFA Enabled

To check if an instance supports EFA we can run the **fi_info -p efa** command, this command queries to see if the efa fabric interface is active. If we run this command on the master:

```bash
$ fi_info -p efa
fi_getinfo: -61
```

We'll see a "Not Found", indicated by the `-61` response. This is because the efa interface is not enabled on the master. In order to accelerate our jobs, we'll need to run on the compute instances. In the following sections we'll spin up a compute instance and examine it again with **fi_info**.

#### Submit a dummy job

First, you have to connect to a compute nodes. In order to do that you have to submit a dummy job as your initial cluster size has been set to 0.

```bash
cat > sleep.sbatch <<EOF
#!/bin/bash

#SBATCH -J sleep
#SBATCH --ntasks=1

/usr/bin/sleep 10m
EOF

sbatch sleep.sbatch
```

#### Check the job status

Starting up a new node will take about 2 minutes. In the meantime you can check the status of the queue using the command **squeue**. The job will be first marked as pending (*PD* state) because resources are being created (or in a down/drained state). 
If you check the [EC2 Dashboard](https://console.aws.amazon.com/ec2), you should see nodes booting up. When ready the nodes will be added automatically to your SLURM cluster, then your job will be processed and you will see a similar status as below.

```bash
squeue
```

![squeue](/images/efa/squeue.png)



#### Check the Compute node status

You can also check the number of nodes available in your cluster using the command **sinfo**. Do not hesitate to refresh it, nodes generally take less than 2 mins to appear. The following example shows one node.

```bash
sinfo
```

![sinfo](/images/efa/sinfo.png)


#### SSH Into the compute nodes from the Master

At this stage your compute nodes is ready and you can connect to it using **ssh**.

```bash
ssh ip-10-0-1-154
```
{{% notice note %}}
You have to replace the ip address shown above **ip-10-0-1-154** with the ip address of your compute node, find it as part of the **sinfo** command in the *NODELIST* column.
{{% /notice %}}

#### Check EFA

Once you are in, you can use the **fi_info** tool to verify whether EFA is active. The tool also provides details about provider support, the available interfaces, as well to validate the libfabric installation:

```bash
fi_info -p efa
```

The output of **fi_info** should be similar to this below:

![fi_info](/images/efa/fi_info.png)


Now you can disconnect from the compute node, just type **exit**.

```
exit 
```

Next, compile and install a simple HPC benchmark.