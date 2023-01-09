---
title: "ParallelCluster using CLI (optional)"
date: 2019-01-24T09:05:54Z
weight: 30
pre: "<b>III ⁃ </b>"
tags: ["HPC", "Introduction", "EC2", "Optional"]
---

{{% notice info %}}This sectional is optional, you can either use the [ParallelCluster Manager UI](02-deploy-pcm.html) or the [CLI](03-parallel-cluster-cli.html).
{{% /notice %}}

![hpc_logo](/images/hpc-aws-parallelcluster-workshop/aws-parallelclusterlogo.png)

This workshop walks you through setting up your own AWS account to run your own HPC workloads. You learn how to navigate the AWS Management Console, access relevant services, and how to deploy a basic infrastructure.
Specifically, you learn how to:

- Sign in to the AWS Management Console and explore it.
- Launch AWS Cloud9, a cloud based IDE, this is your portal to the AWS Command Line Interface (AWS CLI).
- Install AWS ParallelCluster
- Submit your first job


[AWS ParallelCluster](https://aws.amazon.com/hpc/parallelcluster/) is an AWS supported open source cluster management tool that helps you to deploy and manage High Performance Computing (HPC) clusters in the AWS Cloud. Built on the open source CfnCluster project, AWS ParallelCluster enables you to quickly build an HPC compute environment in AWS. It automatically sets up the required compute resources, Slurm Scheduler and shared file system. AWS ParallelCluster facilitates quick start proof of concept deployments and production deployments. You can also build higher level workflows, such as a genomics portal that automates an entire DNA sequencing workflow, on top of AWS ParallelCluster.

{{% notice info %}}This lab requires an AWS Cloud9 IDE. If you do not have an AWS Cloud9 IDE set up, complete sections *a. Sign in to the Console* through *d. Work with the AWS CLI* in the [**Getting Started in the Cloud**](/02-aws-getting-started.html) workshop.
{{% /notice %}}

In this lab, you are introduced to [AWS ParallelCluster](https://aws.amazon.com/hpc/parallelcluster/) and how to run your HPC jobs in AWS as you would on-premises. This workshop includes the following steps:

- Install and configure ParallelCluster on your AWS Cloud9 IDE.
- Create your first cluster.
- Submit a sample job and check what is happening in the background.
- Delete the cluster.

---
AWS ParallelCluster Architecture
---
The architecture, comprising of various AWS services, for deploying a HPC cluster in the cloud is represented in the figure below:

![pc_arch](/images/hpc-aws-parallelcluster-workshop/pc-architecture.png)

<!-- Total cost to run this lab is expected to be less than **two dollars should you run it on your own or company account** if the guide is followed as discussed, in one sitting, and including the deletion of all resources outlined through the guide. -->
