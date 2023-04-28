---
title: "Hybrid HPC"
date: 2023-04-11T09:05:54Z
weight: 30
pre: "<b>Lab III - </b>"
tags: ["HPC", "Hybrid"]
---
In this lab we will setup a Hybrid system. To keep things simple, two Clusters will be setup and configured in AWS. The first Cluster is to replicate the On-prem environment, the second to replicate a Cluster running in the Cloud.

This Lab builds on the previous labs and adds two extra aspects. First we federate the two clusters, this allows jobs to be submitted and run on either cluster. Second we setup File Cache, this acts as a cache and enables applications running on the Cloud Cluster to work with data saved on the On-prem Cluster.

- Test and validate the HPC setup 
- Configure Slurm Federation
- Enable File Cache

{{% notice info %}} When following these instructions, be careful to run the commands on the correct machines. Some commands run on the Cloud9 instance, some must be run on the respective cluster.
{{% /notice %}}
