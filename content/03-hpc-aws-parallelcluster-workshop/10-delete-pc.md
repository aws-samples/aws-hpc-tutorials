+++
title = "i. Terminate Your Cluster"
date = 2019-09-18T10:46:30-04:00
weight = 110
tags = ["tutorial", "create", "ParallelCluster"]
+++

{{% notice note %}}
Note: If you are continuing on to the next workshops, then you will want to clean up the ParallelCluster configuration you just created. Files stored in the Amazon S3 bucket and on AWS Cloud9 will incur small charges (less than a dollar a month if the tutorial was followed as written.) The Cloud9 IDE will stop (not terminate) 30 minutes after the web tab is closed and can be started again, through the console, when needed.
{{% /notice %}}

Now that you are done with your cluster, we can delete it using the following command in your AWS Cloud9 terminal.

```bash
pcluster delete hpclab-yourname -r $AWS_REGION
```

The cluster and all its resources will be deleted by CloudFormation. You can check the status in the [CloudFormation Dashboard](https://console.aws.amazon.com).
