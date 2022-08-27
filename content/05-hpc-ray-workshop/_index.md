---
title: "Ray Clusters on Amazon EC2"
date: 2022-08-18
weight: 50
pre: "<b>Part III ⁃ </b>"
tags: ["Ray", "Overview"]
---

#### Ray Cluster in Nutshell

Ray is an open source technology for distributed AI and Python applications.

(TODO: add brief description of ray clusters)

![ray-cluster-arch](/images/hpc-ray-workshop/ray-cluster.jpg)

#### What you will do in this part of the lab

In this workshop, you will learn how to set up a Ray cluster on [Amazon EC2](https://aws.amazon.com/ec2/), and train a [PyTorch](https://pytorch.org/) model. The workshop includes the following steps:

- Create IAM roles to be used by the head and worker nodes in the cluster
- Set up security groups
- Create an AMI to be used by head and worker nodes in the cluster
- Set up [Amazon FSx for Luster](https://aws.amazon.com/fsx/lustre/) (FSxL) filesystem
- Set up [Amazon CloudWatch](https://aws.amazon.com/pm/cloudwatch/) agent for resource monitoring
- Spin up Ray cluster
- Train PyTorch ResNet50 model on image dataset
