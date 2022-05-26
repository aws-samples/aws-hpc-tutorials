+++
title = "e. Terminate Your Cluster"
date = 2019-09-18T10:46:30-04:00
weight = 60
tags = ["tutorial", "delete", "ParallelCluster"]
+++

Now that you are done with your HPC cluster, you can delete it.

From the **pcluster manager** console, choose **Delete** and confirm to start the cluster deletion.

![Delete Cluster](/images/container-pc/delete.png)

The cluster and all its resources will be deleted by AWS CloudFormation. You can check the status on the **Stack Events** tab.

![Delete Cluster](/images/container-pc/delete-stack-events.png)
