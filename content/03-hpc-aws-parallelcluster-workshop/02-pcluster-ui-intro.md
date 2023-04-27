+++
title = "b. About AWS ParallelCluster UI"
date = 2023-04-10T10:46:30-04:00
weight = 10
tags = ["tutorial", "ParallelCluster"]
+++

![hpc_logo](/images/hpc-aws-parallelcluster-workshop/parallelcluster-ui.svg)

[AWS ParallelCluster UI](https://docs.aws.amazon.com/parallelcluster/latest/ug/pcui-using-v3.html) is a web-based interface that provides the ability to create, monitor and manage clusters. The AWS ParallelCluster UI is installed and accessed in your AWS account. It is designed to mirror the `pcluster` CLI functionality. 

![pcluster-ui-image](/images/hpc-aws-parallelcluster-workshop/pcluster-ui-image.png)

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

### How It Works

![pcluster_ui_arch](/images/hpc-aws-parallelcluster-workshop/pcluster-ui-architecture.png)


{{% notice info %}} AWS ParallelCluster UI official documentation to configure and create a cluster can be found [here](https://docs.aws.amazon.com/parallelcluster/latest/ug/configure-create-pcui-v3.html). 
{{% /notice %}}

{{% notice info %}} AWS ParallelCluster UI does not support AWS Batch.
{{% /notice %}}