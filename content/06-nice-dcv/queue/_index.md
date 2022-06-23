---
title: "DCV Queue in ParallelCluster"
date: 2019-01-24T09:05:54Z
weight: 30
tags: ["HPC", "NICE", "Visualization", "Remote Desktop"]
---

![DCV Queue](/images/nice-dcv/dcv-queue.png)

{{% notice info %}}
This lab requires a cluster setup, please follow instructions in [**Create an HPC Cluster**](/03-hpc-aws-parallelcluster-workshop.html) section of the workshop before proceeding further.
{{% /notice %}}


In this lab, you modify an existing cluster to add a NICE DCV queue. This allows you to spin up workstations on the fly and has the following advantages over the [DCV Connect in ParallelCluster](/06-nice-dcv/pcluster.html) setup:

* DCV instances are ephemeral
* Support for Multi-User if AD is setup 
* Support for mulitple DCV sessions
* Automatic Session timeout
* Support for Multiple Instance Types