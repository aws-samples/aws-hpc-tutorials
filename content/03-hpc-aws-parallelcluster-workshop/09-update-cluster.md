+++
title = "g. Update your cluster"
date = 2022-03-01T10:46:30-04:00
weight = 100
tags = ["tutorial", "create", "ParallelCluster"]
+++

We have sucessfully built your cluster and ran your first MPI job.

Let's say you want to change your instance type to a different instance type in your compute fleet for example **m5.xlarge** . In this lab, we will learn how to update your cluster with new instance type.


Go back to your AWS Cloud9 environment, and list the cluster name (if you don't remember it).

```bash
pcluster list-clusters
```

Edit your original configuration file and change `InstanceType: m5.xlarge`

```bash
vi config.yaml
```

```yaml
- Name: compute
  ComputeResources:
    - Name: m5xlarge
      InstanceType: m5.xlarge
```

You would need to stop the cluster (the compute fleet) using the following command:
```bash
pcluster update-compute-fleet --cluster-name hpc --status STOP_REQUESTED
```

Then run a **pcluster update-cluster** command
```bash
pcluster update-cluster --cluster-name hpc --cluster-configuration config.yaml
```

Start your cluster again after update process is completed.

```bash
pcluster update-compute-fleet --cluster-name hpc --status START_REQUESTED
```

You can now login to your cluster and run your helloworld job again. You can see that the cluster compute node has changed to m5.xlarge.

```bash
[ec2-user@ip-172-31-39-157 ~]$ sinfo
PARTITION AVAIL  TIMELIMIT  NODES  STATE NODELIST 
compute*     up   infinite      8  idle~ compute-dy-m5xlarge-[1-8] 
```

Now you have a better understanding on how AWS ParallelCluster operates. For more information, see the [Configuration](https://docs.aws.amazon.com/parallelcluster/latest/ug/cluster-configuration-file-v3.html) section of the *AWS ParallelCluster User Guide*.
