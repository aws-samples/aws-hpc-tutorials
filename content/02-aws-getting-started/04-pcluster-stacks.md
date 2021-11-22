+++
title = "c. Post-Event: Deploy PCluster Manager (Skip)"
weight = 60
tags = ["tutorial", "cloud9", "ParallelCluster"]
+++

{{% notice note %}}
Skip this step if you are doing the labs during the re:Invent workshop.
You can skip this step if you are following this workshop during re:Invent. In that case you will deploy PCluster Manager later on in the workshop.
{{% /notice %}}


AWS ParallelCluster is an open source cluster management tool that makes it easy to deploy and manage HPC clusters on AWS. With its latest major release, ParallelCluster includes a [RESTful API](https://docs.aws.amazon.com/parallelcluster/latest/ug/api-reference-v3.html). This capability makes it possible to manage HPC clusters through an API hosted on AWS and to easily manage or script clusters' entire lifecycles with scripting languages like Python. This capability can be helpful for creating scripted or event-driven workflows, such as triggering cluster creation when a specific dataset is uploaded to an S3 bucket or when an on-premises cluster is being fully utilized and is unable to accept additional jobs.

PCluster Manager is a sample web-based user interface that can be built from the ParallelCluster CLI and that uses the ParallelCluster API to manage your compute clusters. It will take about 20 minutes to deploy the resources for PCluster Manager and the associated ParallelCluster API. By initiating the deployment now you should have these resources ready by the time you need them.

##### Step 1

Deploy the Pcluster Manager stack by clicking on this link: [Pcluster Manager Stack](https://console.aws.amazon.com/cloudformation/home?#/stacks/create/parameters?stackName=pcluster-manager&templateURL=https://pcluster-manager-us-east-1.s3.amazonaws.com/pcluster-manager.yaml)

##### Step 2

The AWS Console opens on the AWS CloudFormation panel to deploy your stack. Update the field *AdminUserEmail* with **a valid email** to receive a temporary password for connecting to the Pcluster Manager user interface. Leave the other settings as is with their default values and click **Next** to proceed to Step 3.

##### Step 3

Scroll down to the bottom of the *Configure stack options* page and click **Next**.

##### Step 4

Scroll down to the bottom of the *Review* page and check the two boxes to acknowledge that this step will create new IAM resources. Once that is done, click **Create stack**.

![Pcluster Manager install](/images/hpc-aws-parallelcluster-workshop/pcmanager-deploy.png)

The stack you have created is deployed using AWS CloudFormation. It will take ~20 minutes to deploy the AWS ParallelCluster API and PCluster Manager web-based interface. In the meantime, you will complete the first part of the lab. Continue to the next page where you will create the configuration that will define your first HPC cluster on AWS.

{{% notice warning %}}
Ensure that you email address you entered when deploying the Pcluster Manager CloudFormation stack is valid. This email will be used to send you the credentials to connect to PCluster Manager. If you do not have access to this email, you will have to delete and recreate the entire PCluster Manager CloudFormation stack, which will delay your progression.
{{% /notice %}}
