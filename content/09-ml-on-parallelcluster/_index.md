---
title: "Distributed Machine Learning"
date: 2020-09-04T15:58:58Z
weight: 600
pre: "<b>IX ⁃ </b>"
tags: ["Machine Learning", "ML", "ParallelCluster", "EFA", "FSx", "Slurm"]
---

{{% notice info %}}This lab requires an AWS Cloud9 IDE. If you do not have an AWS Cloud9 IDE set up, complete sections *a. Sign in to the Console* through *d. Work with the AWS CLI* in the [**Getting Started in the Cloud**](/02-aws-getting-started.html) workshop.
{{% /notice %}}

In this workshop, you'll learn how to use [AWS ParallelCluster](https://aws.amazon.com/hpc/parallelcluster/) with [ EFA ](https://aws.amazon.com/hpc/efa/) and [FSx for Lustre](https://aws.amazon.com/fsx/lustre/) to:

 - Create a new cluster with preconfigured [Conda](https://docs.conda.io/projects/conda/en/latest/index.html) environments.
 - Upload training data from an AWS Cloud9 instance to an Amazon S3 bucket.
 - Set up a distributed file system using [FSx for Lustre](https://aws.amazon.com/fsx/lustre/) and preprocess the training data with a [Slurm](https://slurm.schedmd.com/documentation.html) job.
 - Run multi-node, multi-GPU data parallel training of a large scale natural language understanding model using the [PyTorch DistributedDataParallel](https://pytorch.org/tutorials/intermediate/ddp_tutorial.html) API.
