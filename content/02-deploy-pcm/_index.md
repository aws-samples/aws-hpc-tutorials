---
title: "ParallelCluster Manager"
date: 2019-01-24T09:05:54Z
weight: 20
pre: "<b>II ⁃ </b>"
tags: ["HPC", "Overview"]
---

![Pcluster Manager Logo](/images/deploy-pcm/parallelcluster-manager.svg)

To deploy AWS ParallelCluster you have two options:

1. **AWS ParallelCluster Manager** This is a Web UI that makes deploying clusters simple. We reccomend this for first time users.
2. **AWS ParallelCluster CLI** This is a CLI tool for deploying clusters.

In the following section we deploy the web based UI, if you'd like to use the CLI instead, skip to [AWS ParallelCluster CLI](04-pcluster-cli.html).

[AWS ParallelCluster Manager](https://github.com/aws-samples/pcluster-manager) is a web UI built for AWS ParallelCluster that makes it easy to create, update, and access HPC clusters. It gives you a quick way to connect to clusters via shell [SSM](https://aws.amazon.com/blogs/aws/new-session-manager/) or remote desktop [DCV](https://aws.amazon.com/hpc/dcv/). The UI is built using the [AWS ParallelCluster API](https://docs.aws.amazon.com/parallelcluster/latest/ug/api-reference-v3.html), making it fully compatible with any cluster 3.X or greater regardless of if you create the cluster through the API, CLI or Web UI.

---
AWS ParallelCluster Manager Architecture
---

AWS ParallelCluster Manager is built on a fully serverless architecture, in most cases it's [completely free](https://github.com/aws-samples/pcluster-manager#costs) to run, you just pay for the clusters themselves.

![pc_arch](/images/deploy-pcm/pcm-architecture.png)
