---
title : "e. Delete Distributed ML Cluster"
date: 2020-09-04T15:58:58Z
weight : 40
tags : ["cleanup", "parallelcluster", "ML"]
---

{{% notice note %}}
Note: Files stored in the Amazon S3 bucket and on AWS Cloud9 will incur charges. The Cloud9 IDE will stop (not terminate) 30 minutes after the web tab is closed and can be started again, through the console, when needed.
{{% /notice %}}

Now that you are done with your cluster, we can delete it using the following command in your AWS Cloud9 terminal.

```bash
pcluster delete-cluster --cluster-name ml-cluster
```

The cluster and all its resources will be deleted by CloudFormation. You can check the status in the [CloudFormation Dashboard](https://console.aws.amazon.com/cloudformation).
