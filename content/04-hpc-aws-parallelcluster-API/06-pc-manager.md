+++
title = "e. ParallelCluster Manager"
date = 2019-09-18T10:46:30-04:00
weight = 70
tags = ["tutorial", "create", "ParallelCluster"]
+++

The AWS ParallelCluster API provides you with many options to manage clusters as part of your workflow or to build custom feature. AWS Pcluster Manager (PCM) is an example of feature built upon the API that provides an Web UI to manage your clusters.


#### About the AWS ParallelCluster Manager

AWS ParallelCluster Manager is a project providing a Web User Interface for AWS ParallelCluster. It enables you to create and manage your clusters through your web browser instead of your terminal and is entirely serverless. Authentication capabilities are provided via Amazon Cognito.

This project has been built to demonstrate the capabilities of the AWS ParallelCluster API and provide an example of interface that you can build using the API.

#### Start with AWS ParallelCluster Manager

In [Part I, step c](/03-hpc-aws-parallelcluster-workshop/04-initialize-api.html) you deployed the AWS ParallelCluster API and AWS Pcluster Manager (PCM). Upon deployment of the PCM stack you should have received an email from Cognito that will look like the one in the image below.

![Pcluster Manager](/images/hpc-aws-parallelcluster-workshop/pcm-email.png)

```bash
pcluster create-cluster --cluster-name my-cluster --cluster-configuration my-cluster-config.yaml --region ${AWS_REGION}
```

Your cluster will take a few minutes to build. The creation status displays in your terminal. Once the cluster is ready, you should see a result similar to the one shown in the following image. Ignore the warning from *node* if you see it.


Run the command below to track the progress of your cluster creation:

```bash
watch -n 5 pcluster list-clusters
````

{{% notice tip %}}
There can be only one cluster of a given name at any time on your account.
{{% /notice %}}

#### What's Happening in the Background

When the **pcluster create-cluster** command is executed, AWS ParallelCluster generates an [AWS CloudFormation](https://aws.amazon.com/cloudformation/) template to generate an infrastructure in AWS. The bulk of the work is done in AWS and once the create is launched, you don't need to keep AWS ParallelCluster running. If you want to see AWS CloudFormation generating the infrastructure, you can view the [CloudFormation console](https://console.aws.amazon.com/cloudformation/). The following image shows cluster creation in the CloudFormation console.

![ParallelCluster CloudFormation](/images/hpc-aws-parallelcluster-workshop/pc-cloudformation2.png)
