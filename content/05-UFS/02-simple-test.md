---
title: "b. Simple Test Case"
weight: 52
tags: ["tutorial", "pcluster-manager", "ParallelCluster", "Spack"]
---

In this section, you will go through the steps to set-up the simple test case on AWS ParallelCluster.

## Download simple test case

The simple test case is a 24 hour forecast starting at 2016-10-03T00:00 UTC.
It is a global mesh with resolution of C96 (~100 km), the test case also uses
the CCPP physics suite FV3_GFS_v15p2. The [NOAA Geophysical
Fluid Dynamics Laboratory website](https://www.gfdl.noaa.gov/fv3/) provides more
information about FV3 and its grids. Further information on the parameterizations
in the suite can be found on the [CCPP website](https://ccpp-techdoc.readthedocs.io/en/latest/Overview.html).


```bash
cd /shared
curl -LO https://ftp.emc.ncep.noaa.gov/EIB/UFS/simple-test-case.tar.gz
tar xf simple-test-case.tar.gz
```

