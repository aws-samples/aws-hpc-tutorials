---
title: "Ray Clusters on Amazon EC2"
date: 2022-08-18
weight: 50
pre: "<b>Part III ⁃ </b>"
tags: ["Ray", "Overview"]
---

#### Ray Cluster in Nutshell

Ray is a distributed computing platform that can be used to scale Python applications with minimal effort. It provides a unified way to scale Python and AI applications from a laptop to a cluster. It is designed to be general-purpose and it can run any kind of workloads. Ray consists of a core distributed runtime and a toolkit of libraries (Ray AIR) for simplifying ML compute.

![ray-cluster-arch](/images/hpc-ray-workshop/ray_air.png)

#### What you will do in this part of the lab

In this workshop, you will learn how to set up a Ray cluster on [Amazon EC2](https://aws.amazon.com/ec2/), and train a [PyTorch](https://pytorch.org/) model. The workshop includes the following steps:

- Create IAM roles to be used by the head and worker nodes in the cluster
- Set up security groups
- Create an AMI to be used by head and worker nodes in the cluster
- Set up [Amazon FSx for Luster](https://aws.amazon.com/fsx/lustre/) (FSxL) filesystem
- Set up [Amazon CloudWatch](https://aws.amazon.com/pm/cloudwatch/) agent for resource monitoring
- Spin up Ray cluster
- Train PyTorch ResNet18 model on Tiny ImageNet dataset
