---
title: "Create a Training Cluster"
weight: 30
pre: "<b>Part II ⁃ </b>"
tags: ["HPC", "Overview"]
---

![AWS ParallelCluster Logo](/images/pcluster/aws-parallelclusterlogo.png)

[AWS ParallelCluster](https://github.com/aws/aws-parallelcluster) is an AWS-supported, open source cluster management tool that makes it easy for you to deploy and manage High Performance Computing (HPC) clusters on AWS. ParallelCluster uses a simple (YAML) text file to model and provision all the resources needed for your HPC applications in an automated and secure manner. We're going to use [pcluster manager](https://github.com/aws-samples/pcluster-manager), which we installed in the **Preparation** section, to  create a cluster.

We've broken the steps down to:

1. Create a Cluster with AWS ParallelCluster
2. Connect to the cluster
3. Get to know the cluster
4. Install Spack package manager
5. Inform Spack of external packages
6. Install Intel compilers and MPI
7. Install NCL
