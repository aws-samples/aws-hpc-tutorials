+++
title = "b. Modify Cluster Configuration"
date = 2019-09-18T10:46:30-04:00
weight = 11
tags = ["tutorial", "NICE DCV", "ParallelCluster", "Remote Desktop"]
+++


In the section we'll add a **DCV** queue to the cluster you created in [**Create an HPC Cluster**](/03-hpc-aws-parallelcluster-workshop.html). 

### ParallelCluster Manager

Click on the cluster in the pcluster manager console and select **Edit**

![Edit Cluster](/images/pcluster/pcmanager-edit.png)

Click on the **Queues** tab and click **Add Queue**

* Name it **dcv** and hit enter to save the name.
* Select **g4dn.xlarge**
* Under **Advanced Options** add the **DCV** security group we created (Optional if using No-Ingress DCV)

![Edit Cluster](/images/nice-dcv/pcmanager-dcvqueue.png)

On the next screen, 

* **Stop** Compute Fleet and click confirm
* **Dryrun** to validate the config
* **Update** to apply the update

![Edit Cluster](/images/pcluster/pcmanager-edit-2.jpeg)

Once the cluster goes into **UPDATE_COMPLETE** make sure to **Start** it:

![Edit Cluster](/images/pcluster/pcmanager-edit-3.png)

### Confirm Update

After the update has completed let's log back into the cluster and check to make sure we see the new queue:

```bash
[ec2-user@ip-172-31-20-178 ~]$ sinfo
PARTITION AVAIL  TIMELIMIT  NODES  STATE NODELIST
compute*     up   infinite     64  idle~ compute-dy-hpc6a-[1-64]
icelake      up   infinite     8   idle~ queue1-dy-icelake-c6i32xlarge-[1-8]
dcv          up   infinite     4   idle~ queue1-dy-dcv-g4dnxlarge-[1-4]
```

You'll see the DCV queue, ensure it's in state **UP** before proceeding.
