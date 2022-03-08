+++
title = "e. Terminate Your Cluster"
date = 2019-09-18T10:46:30-04:00
weight = 110
tags = ["tutorial", "create", "ParallelCluster", "NICE DCV", "Remote Desktop"]
+++

Now that you are done with your cluster, we can delete it using the following command in your AWS Cloud9 terminal.

```bash
pcluster delete-cluster --cluster-name my-dcv-cluster
```

The cluster and all its resources will be deleted by CloudFormation. You can check the status in the [CloudFormation Dashboard](https://console.aws.amazon.com/cloudformation).
