---
title: "AWS ParallelCluster API"
date: 2019-01-24T09:05:54Z
weight: 40
pre: "<b>Part II ⁃ </b>"
tags: ["HPC", "API", "ParallelCluster", "PCluster"]
---

In [Part I](/03-hpc-aws-parallelcluster-workshop.html) you created an HPC system in the cloud using the AWS ParallelCluster CLI and submitted a test MPI job. In Part II, you will run through the following steps:

- Use the [AWS ParallelCluster API](https://docs.aws.amazon.com/parallelcluster/latest/ug/api-reference-v3.html) to manage your HPC cluster programmatically with a Python interface.
- Interact with the API using a web interface that will call the API on your behalf.

#### About the AWS ParallelCluster API

AWS ParallelCluster API is a serverless application that once deployed to your AWS account will enable programmatic access to AWS ParallelCluster features via an API.

AWS ParallelCluster API is distributed as a self-contained AWS CloudFormation template mainly consisting of an Amazon API Gateway endpoint, that exposes AWS ParallelCluster features, and an AWS Lambda function, that takes care of executing the invoked features.


#### Why use the AWS ParallelCluster API

The ability to manage HPC clusters through an API provides several advantages over the use of the CLI:

1. It makes easier to create even-driven and scripted workflows.
2. As part of these workflows, you can consider your HPC clusters as ephemeral. Which means that they will only exist for the duration of the computational stage were they are needed and terminated once your computations is completed.
3. It enables you to abstract the cluster management piece and create clusters from templates that can be customized for specific computational stages.

Using this API you can have an AWS EventBridge rule that checks if files are stored in a particular Amazon S3 bucket, trigger the creation of a cluster through an AWS Lambda function, process the file, then trigger the termination of the cluster once done.


#### AWS ParallelCluster API Architecture

A high level of AWS ParallelCluster API is shown in the image below:

![PCluster Manager install](https://docs.aws.amazon.com/parallelcluster/latest/ug/images/API-Architecture.png)

{{% notice tip %}}AWS ParallelCluster API provides you with the ability to create and manage cluster programmatically. You can call this API using an AWS Lambda function triggered when a new file is stored in an Amazon S3 bucket or to trigger the creation of a dedicated cluster to process a stream of jobs then shutdown.
{{% /notice %}}
