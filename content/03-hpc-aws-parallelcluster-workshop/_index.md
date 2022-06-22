---
title: "Create an HPC Cluster"
date: 2019-01-24T09:05:54Z
weight: 30
pre: "<b>Part I ⁃ </b>"
tags: ["HPC", "Overview"]
---

#### AWS ParallelCluster in a nutshell

AWS ParallelCluster gives you a clean way to define the infrastructure-as-code for your HPC system, you can easily create numerous clusters tailored to the requirements of individual applications or ML workloads. For example, you can create one cluster for ML training workloads requiring high-end GPUs like Nvidia A100 on [p4d.24xlarge](https://aws.amazon.com/ec2/instance-types/p4/) coupled with a [high-performance parallel file system](https://docs.aws.amazon.com/fsx/latest/LustreGuide/what-is.html) and define another cluster with CPU-optimized instances [c5.24xlarge](https://aws.amazon.com/ec2/instance-types/c5/) for data preparation. With AWS ParallelCluster regardless of the workload, you can use the same services and HPC architectures.

![pcluster-arch](/images/hpc-aws-parallelcluster-workshop/pc-how-it-works.png)

Another key feature of AWS ParallelCluster is that you can connect to your cluster with [NICE DCV](https://docs.aws.amazon.com/dcv/latest/adminguide/what-is-dcv.html) to visualize and post-process your data [remotely](https://docs.aws.amazon.com/parallelcluster/latest/ug/dcv-v3.html) with a virtual desktop. This way you can save time and egress charges by eliminating the need to transfer your data out of AWS!

AWS ParallelCluster provides [several commands](https://docs.aws.amazon.com/parallelcluster/latest/ug/commands-v3.html) you can use to manage your cluster such as listing your clusters and their instances, updating a cluster with a new configuration, and shutting down a cluster.

To create a cluster you need to provide to AWS ParallelCluster a text configuration file that specifies the defining features of your cluster (e.g., how many nodes it can scale to, what kind of shared storage it uses). AWS ParallelCluster translates those specifications into an AWS CloudFormation template and uses the template to deploy an HPC system based on those settings.

In this lab, you will use AWS ParallelCluster through PCluster Manager (PCM). PCM is an open-source project that provides an web-interface on top of ParallelCluster.

#### What you will do in this part of the lab

In this lab, you are introduced to [AWS ParallelCluster](https://aws.amazon.com/hpc/parallelcluster/) using [PCluster Manager](https://github.com/aws-samples/pcluster-manager). This workshop includes the following steps:

- Connect to PCluster Manager.
- Create your HPC cluster in AWS.
- Connect to your new cluster via the PCluster Manager console.
- Submit a sample job and check what is happening in the background.

Before proceeding to the next stage, let's review what is AWS ParallelCluster and dive into AWS ParallelCluster API.
