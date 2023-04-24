---
title: "Cleanup"
weight: 60
pre: "<b>Part IV ⁃ </b>"
tags: ["HPC", "Overview"]
---

When we're done with the workshop we can cleanup resources. There's three different ways to do this. For most users, deleting the cluster is the right approach as the FSx Lustre filesystem can be expensive to keep running.

* [**a. Stop Cluster**](/06-cleanup/01-stop-cluster.html) when you stop the resources you'll still be charged for the filesystem, but not for the running EC2 Instances. This is a good way to preserve state in case you want to return to the workshop at a later date. If you used the 1,200 GB FSx Lustre filesystem specified in the template this will cost **$720/month** while stopped.
* [**b. Delete Cluster**](/06-cleanup/02-delete-cluster.html) This will delete all resources in the cluster, including the headnode, compute nodes and filesystem and stop costing money. For most users, do this step and resume later by saving data into S3 then restoring from that S3 bucket.
* [**c. Delete ParallelCluster UI**](/06-cleanup/02-delete-pcm.html) Deleting ParallelCluster UI after deleting the cluster will completely remove everything created in the account, however since it's built on a serverless architecure, ParallelCluster UI costs [next to nothing](https://github.com/aws-samples/pcluster-manager/blob/main/README.md#costs) to keep running so it's recommended to keep it for future work.