---
title: "e. Scaling Graphs"
weight: 45
tags: ["tutorial", "pcluster-manager", "ParallelCluster", "WRF"]
---

We tested the performance and scaling of MPAS in collaboration with [DTN](https://www.dtn.com/weather/) using the [Hurricane Laura](https://www.nhc.noaa.gov/archive/2020/LAURA_graphics.php), a deadly and destructive Category 4 hurricane that made landfall in Louisiana on August 29, 2020. The model resolution is 15km-Global with refined 3-km grid/mesh over the Gulf of Mexico. We ran this simulation on multiple instance types, including the [hpc6a.48xlarge](https://aws.amazon.com/ec2/instance-types/hpc6/), and [c5n.18xlarge](https://aws.amazon.com/ec2/instance-types/c5/) instances.

In the following charts we use two metrics, **Simulation Speed** and **Cost per Simulation**, we define those as follows:

* `Simulation Speed = forecast time (sec) / Wall-clock Time (sec)`
* `Cost Per Simulation ($) = Wall-clock Time * EC2 On-Demand Compute Cost (us-east-2 pricing) * # instances`

![WRF Scaling Per-Node](/images/mpas/performance.png)

At 256 instances (24,576 cores), Hpc6a achieves **1 HR forecast in 0.57 min** (compute + file i/o) with 99% parallel
efficiency, a **149% speedup** over C5n.

![WRF Price Performance](/images/mpas/cost-per-simulation.png)

![WRF Scaling Per-Core](/images/mpas/cost-v-performance.png)

At 64 instances, Hpc6a shows **126% performance improvement** while also being **67% cheaper** than C5n