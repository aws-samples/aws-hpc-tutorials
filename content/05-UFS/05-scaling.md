---
title: "e. Scaling Graphs"
weight: 55
tags: ["tutorial", "pcluster-manager", "ParallelCluster", "UFS"]
---

We tested the performance and scaling of FV3GFS with a 10-day global forecast with a resolution of approximately **13 km (C768)**. As shown below, we ran scale-up tests across 9 to 144 [hpc6a.48xlarge](https://aws.amazon.com/ec2/instance-types/hpc6/) instances measuring total wall-clock times (compute + file I/O). We see the performance scales linearly to 64 instances then tapers off as we go out to 144 instances.

In the following charts we use two metrics, **Simulation Speed** and **Cost per Simulation**, we define those as follows:

* `Simulation Speed = forecast time (sec) / Compute Time (sec)`
* `Cost Per Simulation ($) = Compute Time * EC2 On-Demand Compute Cost (us-east-2 pricing) * # instances`

![UFS Scaling Per-Node](/images/ufs/performance.png)