---
title: "Serverless Computing"
date: 2019-01-24T09:05:54Z
weight: 200
pre: "<b>Lab II ⁃ </b>"
tags: ["HPC", "Serverless", "Lambda", "API Gateway", "AWS ParallelCluster", "AWS Systems Manger"]
---

{{% notice info %}}This lab requires an AWS Cloud9 IDE. If you do not have an AWS Cloud9 IDE set up, complete sections [*a. Sign in to the Console*](/02-aws-getting-started/03-aws-console-login.html) through [*c. Work with the AWS CLI*](/02-aws-getting-started/05-start-aws-cli.html) in the [**Lab Prep - Before Starting**](/02-aws-getting-started.html). This lab will use the cluster created using AWS ParallelCluster. If you have not created a cluster, complete the [**Create an HPC Cluster**](/03-hpc-aws-parallelcluster-workshop.html) lab before proceeding further.
{{% /notice %}}

A [serverless](https://aws.amazon.com/serverless/) architecture enables you to build and run applications and services without having to manage an infrastructure. Your application still runs on servers, but all the heavy lifting is done by AWS on your behalf. This means that you can focus on the core product and no longer need to explicitly provision, scale, and maintain servers to run your applications, databases, and storage systems. This reduced overhead lets you reclaim time and energy that can be spent on developing and operating on a reliable infrastructure at scale.

In this lab you will be led to build an HTTPS front-end to the Slurm scheduler. This front-end will be composed of an HTTPS API and a serverless function that will translate the HTTPS requests to Slurm commands and run them through a secure channel. This lab provides you with the opportunity to use serverless functions (called AWS Lambda). If you want to evaluate serverless computing with containers, you can go through the lab [Simulations on AWS Batch](/06-aws-batch.html).

#### Services used during this lab

In this lab you will combine the following services:

- [AWS ParallelCluster](https://aws.amazon.com/hpc/parallelcluster/) enables you to create an HPC system in AWS.
- [AWS Lambda](https://aws.amazon.com/lambda/) are serverless functions in AWS.
- [AWS Systems Manager](https://aws.amazon.com/systems-manager/) provides the secure channel interface to communicate with your instance.
- [Amazon API Gateway](https://aws.amazon.com/api-gateway/) provides the API interface to your Lambda Function.

<!-- to allow an HTTP interaction with the scheduler running on your cluster. You can submit, monitor, and terminate jobs using the API, instead of connecting to the head node of your cluster via SSH. This makes it possible to integrate AWS ParallelCluster programmatically with other applications running on premises or on AWS. -->

The API uses [AWS Lambda](https://aws.amazon.com/lambda/) and [AWS Systems Manager](https://aws.amazon.com/systems-manager/) to execute the user commands without granting direct SSH access to the nodes, thus enhancing the security of whole cluster.


#### Key topics covered in this lab

During this lab you will learn to:

 - Understand what are serverless functions.
 - Implement a serverless architecture.
 - Build an API using a gateway.

#### Why not using the Slurm REST API?

Slurm provides its own [REST](https://slurm.schedmd.com/rest.html) interface with it's own API semantics. If you are exclusively using Slurm , this is a great option to look at. If you target portability, then this lab will be of interest as it enables you to host different schedulers and container orchestrators under the same common interface.

Furthermore, the infrastructure you will deploy here provides you with additional functionalities such as linear scaling or security features such as throttling of the API calls to protect your backend. There's much more you could do as well!



