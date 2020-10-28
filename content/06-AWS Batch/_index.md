---
title: "Simulations on AWS Batch"
date: 2019-01-24T09:05:54Z
weight: 400
pre: "<b>Opt I ⁃ </b>"
tags: ["HPC", "Overview", "Batch"]
---

{{% notice info %}}
This workshop requires an AWS Cloud9 IDE. If you do not have an AWS Cloud9 IDE set up, complete sections *a. Sign in to the Console* through *d. Work with the AWS CLI* in the [Getting Started in the Cloud](/02-aws-getting-started.html) workshop.
{{% /notice %}}

In this workshop, you learn how to run a driving simulation with [CARLA](http://carla.org/) that outputs sensor data used in later stages of a workflow. CARLA is an interactive driving simulator used to support development, training, and validation of autonomous driving systems.

<video width="640" height="240" controls>
  <source src="/images/carla.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>

This includes the following steps:

- Set up the infrastructure for AWS Batch.
- Upload a container with the simulation.
- Build an Amazon Machine Image (AMI) containing CARLA and the Amazon ECS agent.
- Run simulations on AWS Batch.
