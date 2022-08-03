---
title: "Distributed Training w/ AWS Batch MNP + Deepspeed + EFA + Habana Gaudi"
date: 2022-07-22T15:58:58Z
weight: 60
pre: "<b>Part IV ⁃ </b>"
tags: ["Machine Learning", "ML", "Batch", "EFA", "DeepSpeed", "Habana", "Gaudi"]
---

{{% notice info %}}This lab requires ability to create VPC, Subnets, AWS Batch Environment and Access to Elastic Container Registry.
{{% /notice %}}

In this workshop, you'll learn how to use [AWS Batch](https://aws.amazon.com/batch/) and in particular the Multi Node Parallel jobs to launch large scale containerized training jobs on Fully Managed clusters:
 - Create a VPC with subnets to launch fully managed instances for the training workload.
 - Create a shared file system (EFS) to share data between the instances
 - Setup a Launch template to automatically mount the File Systems into the instances launched in the setup
 - Create an AWS Batch Compute Environment and queue to Launch instances based on the launch template
 - Create an Elastic Container Registry with the containerized large scale training based on PyTorch + DeepSpeed + EFA + Gaudi accelerators (HPU)
 - Create a Multi Node Parallel Job Definition to automatically launch multiple containers on the instances that can communicate with each other during the training process.
 - Run multi-node, multi-HPU data parallel training of a large scale natural language understanding model using the [PyTorch + DeepSpeed](http://deepspeed.ai)


** Steps 1, 2, 3 for the Gaudi Accelerator is identical to the GPU and has been replicated here for completeness ** 