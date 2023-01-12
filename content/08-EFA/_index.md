---
title: "Elastic Fabric Adapter (EFA)"
date: 2020-04-24T7:05:54Z
weight: 500
pre: "<b>VIII ⁃ </b>"
tags: ["HPC", "EFA", "Elastic Fabric Adapter", "Network", "MPI"]
---

![efa_logo](/images/efa/efa.png)

[Elastic Fabric Adapter (EFA)](https://aws.amazon.com/hpc/efa/) is a network interface for Amazon EC2 instances that enables customers to run applications requiring high levels of inter-node communications at scale on AWS. Its custom-built operating system (OS) bypass hardware interface that enhances the performance of inter-instance communications, which is critical to scaling these applications. With EFA, High Performance Computing (HPC) applications using the Message Passing Interface (MPI) and Machine Learning (ML) applications using NVIDIA Collective Communications Library (NCCL) can scale to thousands of CPUs or GPUs. As a result, you get the application performance of on-premises HPC clusters with the on-demand elasticity and flexibility of the AWS cloud.

EFA is available as an optional EC2 networking feature that you can enable on any supported EC2 instance at no additional cost. Plus, it works with the most commonly used interfaces, APIs, and libraries for inter-node communications, so you can migrate your HPC applications to AWS with little or no modifications.

{{% notice note %}}
Follow the instructions in the [Create an HPC Cluster](/05-create-cluster.html) lab before starting this section. We'll be using the cluster you created there.
{{% /notice %}}

In this workshop, you will learn how to use [EFA](https://aws.amazon.com/hpc/efa/) with [AWS ParallelCluster](https://aws.amazon.com/hpc/parallelcluster/) and complete the following steps:

- Examine EFA on the HeadNode and Compute Nodes
- Complile a common MPI benchmarks from [Ohio State University (OSU) ](http://mvapich.cse.ohio-state.edu/benchmarks/) 
- Run the OSU Benchmark for bandwidth and latency.
- Delete the cluster.