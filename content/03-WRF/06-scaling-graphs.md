---
title: "f. Scaling Graphs"
weight: 36
tags: ["tutorial", "pcluster-manager", "ParallelCluster", "WRF"]
---

We tested the performance and scaling of WRF using the [CONUS 2.5-Km](https://www2.mmm.ucar.edu/wrf/users/benchmark/benchdata_v422.html) model from NCAR on multiple instance types, including the [hpc6a.48xlarge](https://aws.amazon.com/ec2/instance-types/hpc6/), [c6i.32xlarge](https://aws.amazon.com/ec2/instance-types/c6i/), and [c5n.18xlarge](https://aws.amazon.com/ec2/instance-types/c5/) instances.

When deciding on the best instance type to use for tightly coupled workloads like WRF, there are multiple factors to consider like time to solution, cost per simulation or both. Based on the WRF conus 2.5KM results **hpc6a.48xlarge** is the optimal instance type from a time to solution and cost per simulation standpoint. **c6i.32xlarge** is the next best option as it also provides on-par performance on a per-core basis and being a general purpose instance is available in more regions. We've included **c5n.18xlarge** as a comparison against older generation instances

{{% notice note %}}
In the previous sections we used the smaller [CONUS 12-Km model](/03-wrf/02-conus-12km.html) as a simple test-case. To test scale up beyond 8 instances you'll want to fetch the [CONUS 2.5-Km](https://www2.mmm.ucar.edu/wrf/users/benchmark/benchdata_v422.html) and follow the same steps to run it.
{{% /notice %}}

In the following charts we use two metrics, **Simulation Speed** and **Cost per Simulation**, we define those as follows: 
* `Simulation Speed = forecast time (sec) / Compute Time (sec)`
* `Cost Per Simulation ($) = Compute Time * EC2 On-Demand Compute Cost (us-east-2 pricing) * # instances`

![WRF Scaling Per-Node](/images/wrf/performance.png)

At 64 instances, Hpc6a provides a **43%** speedup over C6i and a **160%** speedup over C5n instances.

![WRF Price Performance](/images/wrf/cost-per-simulation.png)

![WRF Scaling Per-Core](/images/wrf/cost-v-performance.png)

At 64 instances, Hpc6a is **63%** cheaper than C6i and **70%** cheaper than C5n.