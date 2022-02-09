---
title: "f. Scaling Graphs"
weight: 36
tags: ["tutorial", "pcluster-manager", "ParallelCluster", "WRF"]
---

The benchmark case used for this blog is the University Corporation for Atmospheric Research (UCAR) [CONUS 2.5-Km](https://www2.mmm.ucar.edu/wrf/users/benchmark/benchdata_v422.html) dataset for WRFv4. We used the first 3 hours of this 6-hour, 2.5 km case covering the Continental U.S (CONUS) domain from November 2019 with a 15-second time step and total of around 90M grid points. Note that in the past, WRFv3 has commonly been benchmarked using a similar CONUS 2.5 km dataset, however, WRFv3 benchmarks are not compatible with WRFv4.

When deciding on the best instance type to use for tightly-coupled workloads like WRF, there are several factors to consider like time to solution, cost per simulation, or both. Scale-up results across 1 to 128 [hpc6a.48xlarge](https://aws.amazon.com/ec2/instance-types/hpc6/) instances are shown below. Note that these WRF results denote compute times (not wall-clock times), since we did not optimize for file I/O in these runs.

Based on the WRF conus 2.5km results, the simulation scales well out to 128 instances. However, the lowest cost for the simulation occurs when 32 instances are used and this also leads to the best cost vs performance as shown below.

{{% notice note %}}
In the previous sections we used the smaller [CONUS 12-Km model](/03-wrf/02-conus-12km.html) as a simple test-case. To test scale up beyond 8 instances you'll want to fetch the [CONUS 2.5-Km](https://www2.mmm.ucar.edu/wrf/users/benchmark/benchdata_v422.html) and follow the same steps to run it.
{{% /notice %}}

In the following charts we use two metrics, **Simulation Speed** and **Cost per Simulation**, we define those as follows:

* `Simulation Speed = forecast time (sec) / Compute Time (sec)`
* `Cost Per Simulation ($) = Compute Time * EC2 On-Demand Compute Cost (us-east-2 pricing) * # instances`

![WRF Scaling Per-Node](/images/wrf/performance.png)