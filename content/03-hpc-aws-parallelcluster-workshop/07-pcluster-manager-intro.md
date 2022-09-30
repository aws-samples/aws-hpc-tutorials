+++
title = "f. About PCluster Manager"
date = 2022-04-10T10:46:30-04:00
weight = 60
tags = ["tutorial", "ParallelCluster", "Manager"]
+++

[PCluster Manager](https://github.com/aws-samples/pcluster-manager) is an open source project that leverages the [AWS ParallelCluster API](https://docs.aws.amazon.com/parallelcluster/latest/ug/api-reference-v3.html) to create a web-based user interface for performing cluster management actions on your HPC clusters. This way you can create and manage your clusters through a web browser with point-and-click actions rather than through your terminal.

PCluster Manager is entirely serverless. Authentication is provided through Amazon Cognito, which is why a valid email is required as part of deploying the PCluster Manager stack. Attendees at the event will be provided an initial login in the following steps.

![pcluster-manager-arch](/images/sc22/pcm-arch.png)

Proceed to the next page to start using PCluster Manager and create clusters with the AWS ParallelCluster API. 
