+++
title = "f. About AWS ParallelCluster UI"
date = 2023-04-10T10:46:30-04:00
weight = 60
tags = ["tutorial", "ParallelCluster", "UI"]
+++

![hpc_logo](/images/hpc-aws-parallelcluster-workshop/parallelcluster-ui.svg)

[AWS ParallelCluster UI](https://docs.aws.amazon.com/parallelcluster/latest/ug/pcui-using-v3.html) is a web UI built for AWS ParallelCluster that makes it easy to create, update, and access HPC clusters. It gives you a quick way to connect to clusters via shell [SSM](https://aws.amazon.com/blogs/aws/new-session-manager/) or remote desktop [NICE DCV](https://aws.amazon.com/hpc/dcv/). The UI is built using the [AWS ParallelCluster API](https://docs.aws.amazon.com/parallelcluster/latest/ug/api-reference-v3.html), making it fully compatible with any cluster 3.X or greater regardless of if you create the cluster through the API, CLI or Web UI.

![pcluster-ui-image](/images/hpc-aws-parallelcluster-workshop/pcluster-ui-image.png)

Authentication for ParallelCluster UI is provided through Amazon Cognito, which is why a valid email is required as part of deploying the PCluster Manager stack. Attendees at ISC23 will provide an initial login in the following steps.

### Benefits
#### Creation of Clusters

Step-by-Step guidance is given for creating (and modifying) a cluster. A dry-run validation of the cluster configuration before deployment allows for checks before resources are used. The underlying text-based provisioning methods are still used, allowing for repeatability of deployment.

#### Monitoring and Managing Clusters

In one web-based interface, it is possible to display:
- The list of clusters you've created in your AWS account with AWS ParallelCluster.
- The available status and details for your listed clusters.
- CloudFormation stack event and AWS ParallelCluster logs that you can use for monitoring.
- The status of jobs that are running on your clusters.
- The list of custom images that you can use to build clusters.
- The list of official images that the UI uses to create clusters.
- The list of users that have access to the AWS ParallelCluster UI. You can add and remove users.

#### Seamless Migration to the Cloud
AWS ParallelCluster supports a wide variety of operating systems and batch schedulers so you can migrate your existing HPC workloads with little to no modifications.

### AWS ParallelCluster UI Architecture

AWS ParallelCluster UI is built on a fully serverless architecture, in most cases it’s completely free to run, you just pay for the clusters themselves.

![pcluster_ui_arch](/images/hpc-aws-parallelcluster-workshop/pcluster-ui-architecture.png)


{{% notice info %}} AWS ParallelCluster UI does not support AWS Batch.
{{% /notice %}}

### Deployment

ParallelCluster UI is deployed as a CloudFormation Stack. As it requires about 20 minutes to deploy, your workshop account already has it deployed.

{{% notice info %}}
If you wish to use these instructions outside the workshop, please choose the appropriate region you with to use from the [ParallelCluster UI docs page](https://docs.aws.amazon.com/parallelcluster/latest/ug/install-pcui-v3.html) to deploy ParallelCluster UI, and follow the install instructions there.
{{% /notice %}}

In the next step you will connect to your running ParallelCluster UI.