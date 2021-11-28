+++
title = "i. Summary"
date = 2019-09-18T10:46:30-04:00
weight = 110
tags = ["tutorial", "initialize", "ParallelCluster"]
+++

Great job! You have deployed a cluster with PCluster Manager and the AWS ParallelCluster API in Part 1 of this workshop. In Part 2, you interacted directly with the API to begin creating workflows. By further extending your codes, you can use the API to virtually run any operational workflow on your clusters such as starting a custom cluster when there's a new project or just run a cluster for the duration of a job and shut it down when finished.

Throughout this workshop you have:
- Configured and deployed your HPC Cluster with PCluster Manager
- Connected and executed a sample application on your HPC Cluster.
- Observed the scaling of instances when jobs are submitted.
- Installed the PCluster Client to interact with the AWS ParallelCluster API.
- Interacted with your cluster via the API and stopped the compute fleet from scaling.

You can learn more about AWS ParallelCluster by visiting the [documentation](https://docs.aws.amazon.com/parallelcluster/latest/ug/what-is-aws-parallelcluster.html) page. The AWS ParallelCluster API can be seen directly on [this page](https://github.com/aws/aws-parallelcluster/tree/develop/api/client/src) should you want to dig further on the functionalities it offers. If you'd like to dive deeper onto PCluster Manager, don't hesitate to bookmark the [open-source repository](https://github.com/aws-samples/pcluster-manager).
