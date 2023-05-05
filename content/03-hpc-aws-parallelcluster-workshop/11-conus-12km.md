+++
title = "j. CONUS 12-km Model"
date = 2023-04-10T10:46:30-04:00
weight = 110
tags = ["tutorial", "create", "ParallelCluster"]
+++

{{% notice note %}}
The steps here can also be executed on any cluster running SLURM. There may be some variations depending on your configuration.
{{% /notice %}}

In this step, you run the WRF [CONUS 12km test case](https://www2.mmm.ucar.edu/wrf/users/benchmark/benchdata_v422.html) job to introduce you to the mechanisms of AWS ParallelCluster.

#### Preparatory Steps

{{% notice info %}}
Make sure that you are logged into the AWS ParallelCluster head node through DCV. To connect to the Head node via DCV, following instructions from part **[h. Connect to the Cluster](/03-hpc-aws-parallelcluster-workshop/08-connect-cluster.html#dcv-connect)**
{{% /notice %}}

#### Download CONUS 12KM
Input data used for simulating the Weather Research and Forecasting (WRF) model are 12-km CONUS input.
These are used to run the WRF executable (wrf.exe) to simulate atmospheric events that took place during the Pre-Thanksgiving Winter Storm of 2019.
The model domain includes the entire Continental United States (CONUS), using 12-km grid spacing, which means that each grid point is 12x12 km.
The full domain contains 425 x 300 grid points. After running the WRF model, post-processing will allow visualization of atmospheric variables available in the output (e.g., temperature, wind speed, pressure). 

The CONUS 12km is a test case provided by NCAR and can be retrieved from the [NCAR/MMM website](https://www2.mmm.ucar.edu/wrf/users/). For this tutorial and convenience, you will download the CONUS 12km test from an [Amazon S3](https://aws.amazon.com/s3/) bucket into the **/shared** directory of the HPC Cluster; **/shared** is the mount point of NFS server hosted on the head node.


Here are the steps:

```bash
cd /shared
curl -O https://www2.mmm.ucar.edu/wrf/OnLineTutorial/wrf_cloud/wrf_simulation_CONUS12km.tar.gz
tar -xzf wrf_simulation_CONUS12km.tar.gz
```

#### Prepare the data
Next we'll prepare the data for a run by copying in the relevant files from our WRF install:

```bash
cd /shared/conus_12km

cp /opt/wrf-omp/src/run/{\
CAMtr_volume_mixing_ratio.*,\
GENPARM.TBL,\
HLC.TBL,\
LANDUSE.TBL,\
RRTM_DATA,\
RRTM_DATA_DBL,\
RRTMG_LW_DATA,\
RRTMG_LW_DATA_DBL,\
RRTMG_SW_DATA,\
RRTMG_SW_DATA_DBL,\
SOILPARM.TBL,\
URBPARM.TBL,\
URBPARM_UZE.TBL,\
VEGPARM.TBL,\
ozone.formatted,\
ozone_lat.formatted,\
ozone_plev.formatted} .
```

Next the job will be submitted to the cluster.