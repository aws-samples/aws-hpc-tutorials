---
title: "e. Scaling Graphs"
weight: 45
tags: ["tutorial", "pcluster-manager", "ParallelCluster", "WRF"]
---

We tested the performance and scaling of MPAS in collaboration with [DTN](https://www.dtn.com/weather/) using the [Hurricane Laura](https://www.nhc.noaa.gov/archive/2020/LAURA_graphics.php), a deadly and destructive Category 4 hurricane that made landfall in Louisiana on August 29, 2020. The model resolution is 15km-Global with refined 3-km grid/mesh over the Gulf of Mexico. As shown below, we ran scale-up tests across 32 to 128 [hpc6a.48xlarge](https://aws.amazon.com/ec2/instance-types/hpc6/) instances, measuring total wall-clock times (compute + file I/O) over a 6hr forecast. Performance scales linearly as we scaled out to 128 instances, with a minimum simulation cost when using 64 instances.

In the following charts we use two metrics, **Simulation Speed** and **Cost per Simulation**, we define those as follows:

* `Simulation Speed = forecast time (sec) / Wall-clock Time (sec)`
* `Cost Per Simulation ($) = Wall-clock Time * EC2 On-Demand Compute Cost (us-east-2 pricing) * # instances`

![MPAS Scaling Per-Node](/images/mpas/performance.png)
