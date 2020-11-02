---
title: "Grafana Dashboards"
date: 2019-01-24T09:05:54Z
weight: 20
tags: ["HPC", "Performance", "Monitoring", "Grafana", "Prometheus", "SQS"]
---

**Solution Components:**

![Grafana Architecture diagram](/images/monitoring/grafana-architecture.png)

This lab is build with the following components:

* [Grafana](https://github.com/grafana/grafana) is an open-source platform for monitoring and observability. Grafana allows you to query, visualize, alert on and understand your metrics as well as create, explore, and share dashboards fostering a data driven culture.

* [Prometheus](https://github.com/prometheus/prometheus/) is an open-source project for systems and service monitoring from the [Cloud Native Computing Foundation](https://cncf.io/). It collects metrics from configured targets at given intervals, evaluates rule expressions, displays the results, and can trigger alerts if some condition is observed to be true.

* [Prometheus Pushgateway](https://github.com/prometheus/pushgateway/) is on open-source tool that allows ephemeral and batch jobs to expose their metrics to Prometheus.

* [Nginx](http://nginx.org/) is an HTTP and reverse proxy server, a mail proxy server, and a generic TCP/UDP proxy server.

* [Prometheus-Slurm-Exporter](https://github.com/vpenso/prometheus-slurm-exporter/) is a Prometheus collector and exporter for metrics extracted from the [Slurm](https://slurm.schedmd.com/overview.html) resource scheduling system.

* [Node_exporter](https://github.com/prometheus/node_exporter) is a Prometheus exporter for hardware and OS metrics exposed by Linux kernels, written in Go with pluggable metric collectors.

This workshop includes the following steps:

- Monitor your HPC Cluster with Prometheus, Node exporter and Grafana using AWS ParallelCluster
  - Create a HPC Cluster with monitoring and sample dashboards setup using AWS ParallelCluster
  - Review the different dashboards
  - Monitor the dashboards with application run

{{% notice info %}}This lab requires an AWS Cloud9 IDE. If you do not have an AWS Cloud9 IDE set up, complete sections *a. Sign in to the Console* through *d. Work with the AWS CLI* in the [**Getting Started in the Cloud**](/02-aws-getting-started.html) workshop.
{{% /notice %}}
