---
title: "Create an HPC Cluster"
date: 2019-01-24T09:05:54Z
weight: 50
pre: "<b>IV ⁃ </b>"
tags: ["HPC", "Overview"]
---

![hpc_logo](/images/hpc-aws-parallelcluster-workshop/aws-parallelclusterlogo.png)

[AWS ParallelCluster](https://aws.amazon.com/hpc/parallelcluster/) is an AWS supported open source cluster management tool that helps you to deploy and manage High Performance Computing (HPC) clusters in the AWS Cloud. Built on the open source CfnCluster project, AWS ParallelCluster enables you to quickly build an HPC compute environment in AWS. It automatically sets up the required compute resources, Slurm Scheduler and shared file system. AWS ParallelCluster facilitates quick start proof of concept deployments and production deployments. You can also build higher level workflows, such as a genomics portal that automates an entire DNA sequencing workflow, on top of AWS ParallelCluster.

- Create your first cluster.
- Submit a sample job and check what is happening in the background.
- Delete the cluster.

---
AWS ParallelCluster Architecture
---
The architecture, comprising of various AWS services, for deploying a HPC cluster in the cloud is represented in the figure below:

![pc_arch](/images/hpc-aws-parallelcluster-workshop/pc-architecture.png)
