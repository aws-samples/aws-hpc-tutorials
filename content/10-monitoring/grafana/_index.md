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

* [Node_exporter](https://github.com/prometheus/node_exporter) is a Prometheus exporter for hardware and OS metrics exposed by Linux kernels, written in Golang with pluggable metric collectors.

This workshop includes the following steps:

1. Create a HPC cluster with performance monitoring dashboards setup using AWS ParallelCluster
2. Login and review the different dashboards
3. Interactively monitor different performance metrics with a sample application run
