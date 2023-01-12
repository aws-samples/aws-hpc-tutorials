---
title: "Simulations with AWS Batch"
date: 2019-01-24T09:05:54Z
weight: 400
pre: "<b>VII ⁃ </b>"
tags: ["HPC", "Overview", "Batch"]
---

*Fully managed batch processing at any scale*

 [AWS Batch](https://aws.amazon.com/batch/) enables developers, scientists, and engineers to easily and efficiently run hundreds of thousands of batch computing jobs on AWS. AWS Batch dynamically provisions the optimal quantity and type of compute resources (e.g., CPU or memory optimized instances) based on the volume and specific resource requirements of the batch jobs submitted. With AWS Batch, there is no need to install and manage batch computing software or server clusters that you use to run your jobs, allowing you to focus on analyzing results and solving problems. AWS Batch plans, schedules, and executes your batch computing workloads across the full range of AWS compute services and features, such as [AWS Fargate](https://aws.amazon.com/fargate/), [Amazon EC2](https://aws.amazon.com/ec2/) and [Spot Instances](https://aws.amazon.com/ec2/spot/).

There is no additional charge for AWS Batch. You only pay for the AWS resources (e.g. EC2 instances or Fargate jobs) you create to store and run your batch jobs.<br> </p> 

***Key advantages of AWS Batch***

**Fully managed**

AWS Batch eliminates the need to operate third-party commercial or open source batch processing solutions. There is no batch software or servers to install or manage. AWS Batch manages all the infrastructure for you, avoiding the complexities of provisioning, managing, monitoring, and scaling your batch computing jobs.

**Integrated with AWS**

AWS Batch is natively integrated with the AWS platform, allowing you to leverage the scaling, networking, and access management capabilities of AWS. This makes it easy to run jobs that safely and securely retrieve and write data to and from AWS data stores such as Amazon S3 or Amazon DynamoDB. You can also run AWS Batch on AWS Fargate, for fully serverless architecture, eliminating the need to manage compute infrastructure.

**Cost optimized resource provisioning**
AWS Batch provisions compute resources and optimizes the job distribution based on the volume and resource requirements of the submitted batch jobs. AWS Batch dynamically scales compute resources to any quantity required to run your batch jobs, freeing you from the constraints of fixed-capacity clusters. AWS Batch will utilize Spot Instances or submit to Fargate Spot on your behalf, reducing the cost of running your batch jobs further.


***Workshop overview***

{{% notice info %}}
This workshop requires an AWS Cloud9 IDE. If you do not have an AWS Cloud9 IDE set up, complete sections *a. Sign in to the Console* through *d. Work with the AWS CLI* in the [Getting Started in the Cloud](/02-aws-getting-started.html) workshop.
{{% /notice %}}


In this workshop you will learn how to create batch jobs that run a computationally intensive task ([stress-ng](https://kernel.ubuntu.com/~cking/stress-ng/)) in various ways. This includes running a single job, supplying different command line parameters to separate tasks of an array job, and defining a job dependency to simulate the flow control of a more complex workflow.

This workshop includes the following major topics:

- Set up the infrastructure for required for the workshop.
- Define, build and upload a container to [Amazon Elastic Container Registry (ECR)](hhttps://aws.amazon.com/ecr/).
- Run a compute intensive task using [AWS Batch](https://aws.amazon.com/batch/).
- Run the compute intensive task in different ways by passing separate command line parameters member tasks of an array job.
- Define a job dependency for conditional execution of related batch jobs.
- Clean up the resources used by this workshop.
