+++
title = "g. Update your cluster"
date = 2022-03-01T10:46:30-04:00
weight = 55
tags = ["tutorial", "create", "ParallelCluster"]
+++

We have successfully built your cluster and ran your first MPI job.

Let's say you want to change your instance type to a different instance type in your compute fleet for example **c6i.32xlarge** . In this lab, we will learn how to update your cluster with new instance type.

### ParallelCluster Manager

Click on the cluster in the pcluster manager console and select **Edit**

![Edit Cluster](/images/pcluster/pcmanager-edit.png)

Click on the **Queues** tab and click **Add Queue**

* Select **c6i.32xlarge**
* Enable **EFA**
* Enable **placement group**

![Edit Cluster](/images/pcluster/pcmanager-edit-1.jpeg)

On the next screen, 

* **Stop** Compute Fleet and click confirm
* **Dryrun** to validate the config
* **Update** to apply the update

![Edit Cluster](/images/pcluster/pcmanager-edit-2.jpeg)

Once the cluster goes into **UPDATE_COMPLETE** make sure to **Start** it:

![Edit Cluster](/images/pcluster/pcmanager-edit-3.png)

### CLI

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

### Confirm Update

After the update has completed let's log back into the cluster and check to make sure we see the new queue:

```bash
[ec2-user@ip-172-31-20-178 ~]$ sinfo
PARTITION AVAIL  TIMELIMIT  NODES  STATE NODELIST
compute*     up   infinite     64  idle~ compute-dy-hpc6a-[1-64]
queue1       up   infinite      8  idle~ queue1-dy-queue1-c6i32xlarge-[1-8]
```

Now you have a better understanding on how AWS ParallelCluster operates. For more information, see the [Configuration](https://docs.aws.amazon.com/parallelcluster/latest/ug/cluster-configuration-file-v3.html) section of the *AWS ParallelCluster User Guide*.
