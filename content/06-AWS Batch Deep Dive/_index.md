---
title: "Deep Dive into AWS Batch"
date: 2019-01-24T09:05:54Z
weight: 300
pre: "<b>VI ⁃ </b>"
tags: ["HPC", "Overview", "Batch"]
---

*Fully managed batch processing at any scale*

 [AWS Batch](https://aws.amazon.com/batch/) enables developers, scientists, and engineers to easily and efficiently run hundreds of thousands of batch computing jobs on AWS. AWS Batch dynamically provisions the optimal quantity and type of compute resources (e.g., CPU or memory optimized instances) based on the volume and specific resource requirements of the batch jobs submitted. With AWS Batch, there is no need to install and manage batch computing software or server clusters that you use to run your jobs, allowing you to focus on analyzing results and solving problems. AWS Batch plans, schedules, and executes your batch computing workloads across the full range of AWS compute services and features, such as [AWS Fargate](https://aws.amazon.com/fargate/), [Amazon EC2](https://aws.amazon.com/ec2/) and [Spot Instances](https://aws.amazon.com/ec2/spot/).

There is no additional charge for AWS Batch. You only pay for the AWS resources (e.g. EC2 instances or Fargate jobs) you create to store and run your batch jobs.<br> </p> 



***Workshop overview***

{{% notice info %}}
This workshop requires an AWS Cloud9 IDE. If you do not have an AWS Cloud9 IDE set up, complete sections *a. Sign in to the Console* through *d. Work with the AWS CLI* in the [Getting Started in the Cloud](/02-aws-getting-started.html) workshop.
{{% /notice %}}


Customers often ask for guidance to optimize their architectures and enable their workload to scale rapidly on AWS Batch. The challenge is that every workload is different and some optimizations may not yield the same results in every use case. 

This workshop includes the following major topics:

- Batch Basics
    - Scaling capacity
    - Job placement
    - Provisioning of instances by Amazon EC2
- Clean up the resources used by this workshop

These learnings apply to Amazon EC2; AWS Fargate is not discussed here.