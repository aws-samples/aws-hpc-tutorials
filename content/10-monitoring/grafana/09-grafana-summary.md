+++
title = "g. Summary"
date = 2019-09-18T10:46:30-04:00
weight = 90
tags = ["tutorial", "Grafana", "ParallelCluster", "Monitoring", "Dashboards"]
+++

In this part of the lab you have seen how metrics can be collected by [Prometheus](https://prometheus.io/docs/introduction/overview/) and visualize them in [Grafana](https://grafana.com/). Prometheus provides a time series database and will connect to each node to collect metrics collected by the [Node Export](https://github.com/prometheus/node_exporter).

The [Node Exporter](https://github.com/prometheus/node_exporter) you used here allows you to visualize system level metrics. There exist other metrics exporters you can integrate on your system such as the followings:

- [DCGM Exporter](https://github.com/NVIDIA/gpu-monitoring-tools#dcgm-exporter) enables your to usage and power metrics from your GPU based nodes.
- [PCP Exporter](https://jronak.github.io/pcp/) provides means to analyze system performance metrics at the kernel level.
- [eBPF Exporter](https://github.com/cloudflare/ebpf_exporter) gives you access to kernel level tracing with [eBPF](http://www.brendangregg.com/ebpf.html) to visualize metrics such as the block IO latency, thread-blocks and more.

There are many [Prometheus exporters](https://prometheus.io/docs/instrumenting/exporters/) readily available and you can even [write your own](https://prometheus.io/docs/instrumenting/writing_exporters/) with a [few lines](https://prometheus.io/docs/instrumenting/clientlibs/) of Go, Python, C, C++ and other languages. In fact, nothing prevents you to build an exporter for your applications and visualize them in Grafana.
