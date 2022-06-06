---
title: "f. Delete Your EFA Cluster"
date: 2020-05-13T09:52:23Z
weight : 50
tags : ["tutorial", "delete", "ParallelCluster"]
---


#### Delete Your EFA Cluster

{{% notice note %}}
Note: If you are keep working on the workshops or moving to the next section, then you will want to clean up the ParallelCluster configuration you just created. The Cloud9 IDE will stop (not terminate) 30 minutes after the web tab is closed and can be started again, through the console, when needed.
{{% /notice %}}

Now that you are done with your EFA cluster, you can delete it.
Disconnect from your Master node first, just type **exit**.

```
exit
```

And then, from a terminal running on your Cloud9 Instance, run the following command.


```bash
pcluster delete-cluster --cluster-name efa-cluster
```

The cluster and all its resources will be deleted by [CloudFormation](https://docs.aws.amazon.com/cloudformation/index.html). You can check the status as command line output or in the [CloudFormation Dashboard](https://console.aws.amazon.com/cloudformation).
