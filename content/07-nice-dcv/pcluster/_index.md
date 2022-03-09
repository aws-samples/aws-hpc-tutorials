---
title: "DCV using ParallelCluster"
date: 2019-01-24T09:05:54Z
weight: 20
tags: ["HPC", "NICE", "Visualization", "Remote Desktop"]
---

{{% notice info %}}This lab will enable Remote Desktop Cloud Visualization (DCV) on the compute server using AWS ParallelCluster. Highly recommend to complete the [**Create an HPC Cluster**](/03-hpc-aws-parallelcluster-workshop.html) section of the workshop before proceeding further.
{{% /notice %}}


In this lab, you are introduced to [NICE DCV](https://aws.amazon.com/hpc/dcv/) and how to deploy an HPC cluster with remote visualization enabled using AWS ParallelCluster. This section of the workshop includes the following steps:

- Configure ParallelCluster with NICE DCV on your AWS Cloud9 IDE.
- Create your first cluster with NICE DCV remote visualization enabled.
- Provision the HPC cluster created above and visualize a simple test program.
- Delete the cluster.
