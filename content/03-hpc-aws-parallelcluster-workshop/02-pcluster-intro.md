+++
title = "a. About PCluster Manager"
date = 2019-09-18T10:46:30-04:00
weight = 20
tags = ["tutorial", "install", "ParallelCluster"]
+++

[PCluster Manager](https://github.com/aws-samples/pcluster-manager) is an open source project that leverages the [AWS ParallelCluster API](https://docs.aws.amazon.com/parallelcluster/latest/ug/api-reference-v3.html) to create a web-based user interface for performing cluster management actions on your HPC clusters. This way you can create and manage your clusters through a web browser with point-and-click actions rather than through your terminal.

PCluster Manager is entirely serverless. Authentication is provided through Amazon Cognito, which is why we asked you to use a valid email as part of deploying PCluster Manager earlier in this workshop.

![pcluster-manager-arch](/images/hpc-aws-parallelcluster-workshop/pcm-arch.png)

Proceed to the next page to start using PCluster Manager and create clusters with the AWS ParallelCluster API.


