---
title: "Performance Monitoring at Scale"
date: 2019-01-24T09:05:54Z
weight: 400
pre: "<b>Lab IV ⁃ </b>"
tags: ["HPC", "Performance", "Monitoring", "Grafana", "Prometheus", "SQS"]
---

Performance monitoring and analysis are critical to deciphering the often complex behavior of HPC environments and applications. They help identify regions of code that are most frequently executed, thus allowing fine-tuning of application behavior for optimal runtime speed and resource usage. Elimination of various inefficiencies either introduced by the programmer or arising due to less than perfect mapping to a specific execution environment is vital to achieving acceptable application execution rates on a HPC cluster and increasing the users productivity.

This lab gives an overview of different methods and tools helpful in assessing application and infrastructure performance of your HPC cluster in the cloud.  

The lab is divided in two sections.

- In the first section, you will monitor your HPC Cluster with Prometheus, Node exporter and Grafana using AWS ParallelCluster. 
- In the second section, you will setup a simple job notification service using Amazon Simple Notification Service (SNS)

Architecture Overview:
![Monitoring Architecture](/images/monitoring/monitoring-arch.png)


{{% notice info %}}This lab requires an AWS Cloud9 IDE. If you do not have an AWS Cloud9 IDE set up, complete sections *a. Sign in to the Console* through *d. Work with the AWS CLI* in the [**Getting Started in the Cloud**](/02-aws-getting-started.html) workshop.
{{% /notice %}}
