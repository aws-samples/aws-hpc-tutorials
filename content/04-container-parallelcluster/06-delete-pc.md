+++
title = "i. Terminate Your Cluster"
date = 2019-09-18T10:46:30-04:00
weight = 60
tags = ["tutorial", "delete", "ParallelCluster"]
+++

Now that you are done with your HPC cluster, you can delete it using the following command in your AWS Cloud9 terminal.

```bash
pcluster delete hpclab-yourname -r $AWS_REGION
```

The cluster and all its resources will be deleted by CloudFormation. You can check the status in the [CloudFormation Dashboard](https://console.aws.amazon.com).