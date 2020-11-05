---
title: "Performance Monitoring"
date: 2019-01-24T09:05:54Z
weight: 400
pre: "<b>Lab IV ⁃ </b>"
tags: ["HPC", "Performance", "Monitoring", "Grafana", "Prometheus", "SQS"]
---

Performance monitoring and analysis are critical to analyze and optimize HPC environments and applications. They help identify application hotspots for compute, memory and storage, thus allowing fine-tuning of application behavior for optimal runtime speed and resource usage.

This lab gives an overview of different methods and tools that can be used to assess application and infrastructure performance of your HPC cluster in the cloud.

The lab is divided in two sections.

1. In the first section, you will monitor your HPC Cluster with [Prometheus](https://github.com/prometheus/prometheus/), an open-source systems monitoring toolkit, and [Grafana](https://github.com/grafana/grafana), a tool to query and visualize data, using AWS ParallelCluster. 
2. In the second section, you will setup a job notification that informs you when your job completes.

Architecture Overview:
![Monitoring Architecture](/images/monitoring/performance_monitoring_architecture.png)


{{% notice info %}}This lab requires an AWS Cloud9 IDE. If you do not have an AWS Cloud9 IDE set up, complete sections *a. Sign in to the Console* through *d. Work with the AWS CLI* in the [**Lab Prep**](/02-aws-getting-started.html) workshop.
{{% /notice %}}
