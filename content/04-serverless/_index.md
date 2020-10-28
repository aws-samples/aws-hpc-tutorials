---
title: "Serverless Computing"
date: 2019-01-24T09:05:54Z
weight: 200
pre: "<b>Lab II ⁃ </b>"
tags: ["HPC", "Serverless", "Lambda", "API Gateway", "AWS ParallelCluster", "AWS Systems Manger"]
---

A [serverless](https://aws.amazon.com/serverless/) architecture is a way to build and run applications and services without having to manage infrastructure. Your application still runs on servers, but all the server management is done by AWS. You no longer have to provision, scale, and maintain servers to run your applications, databases, and storage systems.

By using a serverless architecture, you can focus on the core product instead of worrying about managing and operating servers or runtimes, either in the cloud or on-premises. This reduced overhead lets you reclaim time and energy that can be spent on developing great products which scale and that are reliable.

In this lab we combine [AWS ParallelCluster](https://aws.amazon.com/hpc/parallelcluster/), [AWS Lambda](https://aws.amazon.com/lambda/), [AWS Systems Manager](https://aws.amazon.com/systems-manager/) and [Amazon API Gateway](https://aws.amazon.com/api-gateway/) to allow an HTTP interaction with the scheduler running on your cluster. You can submit, monitor, and terminate jobs using the API, instead of connecting to the head node of your cluster via SSH. This makes it possible to integrate AWS ParallelCluster programmatically with other applications running on premises or on AWS.

The API uses [AWS Lambda](https://aws.amazon.com/lambda/) and [AWS Systems Manager](https://aws.amazon.com/systems-manager/) to execute the user commands without granting direct SSH access to the nodes, thus enhancing the security of whole cluster.

Key topics covered in this lab:

 - How to use serverless architectures for HPC applications
 - Using AWS Lambda, Amazon API Gateway, and AWS Systems Manager to implement the serverless architecture
 - Using AWS ParallelCluster with serverless API

Below is the serverless architecture which shows the components required to create the cluster and interact with the solution
![Serverless Architecture](/images/serverless/serverless-arch2.png)

This workshop includes the following steps:

- Create a sample S3 bucket
- Create custom IAM policy to call AWS Lambda and AWS Systems Manager endpoints.
- Update the policy in AWS ParallelCluster and re-deploy the cluster.
- Create AWS Lambda function to execute scheduler (Slurm) commands in the cluster head node.
- Execute the AWS Lambda function with the Amazon API Gateway.
- Interact with the cluster from outside the head node.
- Delete the cluster.


{{% notice info %}}This lab requires an AWS Cloud9 IDE. If you do not have an AWS Cloud9 IDE set up, complete sections *a. Sign in to the Console* through *d. Work with the AWS CLI* in the [**Getting Started in the Cloud**](/02-aws-getting-started.html) workshop. This lab will use the cluster created using AWS ParallelCluster. If you have not created a cluster, complete the [**Create an HPC Cluster**](/03-hpc-aws-parallelcluster-workshop.html) section of the workshop before proceeding further.
{{% /notice %}}

