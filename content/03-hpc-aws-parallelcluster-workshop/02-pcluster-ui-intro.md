+++
title = "b. Deploy AWS ParallelCluster UI"
date = 2023-04-10T10:46:30-04:00
weight = 15
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

AWS ParallelCluster UI is built on a fully serverless architecture, in most cases it’s [completely free](https://github.com/aws-samples/pcluster-manager#costs) to run, you just pay for the clusters themselves.

![pcluster_ui_arch](/images/hpc-aws-parallelcluster-workshop/pcluster-ui-architecture.png)


{{% notice info %}} AWS ParallelCluster UI does not support AWS Batch.
{{% /notice %}}

### Deployment

ParallelCluster UI is deployed as a CloudFormation Stack. As it'll take about 20 minutes to deploy, we will start deployment now.

1. Deploy the ParallelCluster UI stack in the **eu-west-1** region by clicking on this button:
{{% button href="https://eu-west-1.console.aws.amazon.com/cloudformation/home?region=eu-west-1#/stacks/create/review?stackName=parallelcluster-ui&templateURL=https://parallelcluster-ui-release-artifacts-us-east-1.s3.us-east-1.amazonaws.com/parallelcluster-ui.yaml" icon="fas fa-rocket" %}}Deploy ParallelCluster UI in Ireland{{% /button %}}

{{% notice warning %}}
If you are running this outside the workshop, and want to use a different Region to that used in this text, please choose the appropriate region from the [ParallelCluster UI docs page](https://docs.aws.amazon.com/parallelcluster/latest/ug/install-pcui-v3.html).
{{% /notice %}}

2. The AWS Console opens on the AWS CloudFormation panel to deploy your stack. Update the field *AdminUserEmail* with **a valid email** to receive a temporary password in order to connect to the ParallelCluster UI GUI. Leave the other fields with their default values and click **Next** to proceed to Step 3.

![ParallelCluster UI install](/images/hpc-aws-parallelcluster-workshop/lab1-pcluster-workshop-02-pcmanager-install.png)

3. Scroll down to the bottom of the Stage 3 page (*Configure stack options*) and click **Next**.
4. Scroll down to the bottom of the Stage 4 page (*Review*) and **click** on the the two tick boxes to create new IAM resources. Once done, click on **Create stack**.

![ParallelCluster UI install](/images/hpc-aws-parallelcluster-workshop/lab1-pcluster-workshop-02-pcmanager-deploy.png)

The stack is deploying using AWS CloudFormation. It will take ~20 minutes to deploy the AWS ParallelCluster API and ParallelCluster UI. Please grab a ☕️ while you wait.

{{% notice warning %}}Ensure that you entered a valid email when deploying the ParallelCluster UI stack. This email will be used to send you the credentials to connect to ParallelCluster UI. If the email you will have to delete and recreate it which may delay your progression.
{{% /notice %}}