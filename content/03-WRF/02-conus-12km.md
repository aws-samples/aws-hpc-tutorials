---
title: "b. CONUS 12-km Model"
weight: 32
tags: ["tutorial", "pcluster-manager", "ParallelCluster", "Spack"]
---

In this section, you will go through the steps to run [test case(s) provided by NCAR](https://www2.mmm.ucar.edu/wrf/users/benchmark/benchdata_v422.html) on AWS ParallelCluster.

## Retrieve CONUS 12KM

Input data used for simulating the Weather Research and Forecasting (WRF) model are 12-km CONUS input. These are used to run the WRF executable (wrf.exe) to simulate atmospheric events that took place during the Pre-Thanksgiving Winter Storm of 2019. The model domain includes the entire Continental United States (CONUS), using 12-km grid spacing, which means that each grid point is 12x12 km. The full domain contains 425 x 300 grid points. After running the WRF model, post-processing will allow visualization of atmospheric variables available in the output (e.g., temperature, wind speed, pressure).

```bash
cd /shared
curl -O https://www2.mmm.ucar.edu/wrf/OnLineTutorial/wrf_cloud/wrf_simulation_CONUS12km.tar.gz
tar -xzf wrf_simulation_CONUS12km.tar.gz
```

Next we'll prepare the data for a run by copying in the relevant files from our WRF install:

```bash
cd /shared/conus_12km/

WRF_ROOT=$(spack location -i wrf%intel)/test/em_real/
ln -s $WRF_ROOT* .
```