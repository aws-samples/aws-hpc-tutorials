+++
title = "l. CONUS 12-km Model"
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
Make sure that you are logged into the AWS ParallelCluster head node through DCV.
{{% /notice %}}
Connect to the Head node via DCV, following instructions from part **[f. Connect to the Cluster](/03-hpc-aws-parallelcluster-workshop/09-connect-cluster.html#dcv-connect)**

#### Download CONUS 12KM
Input data used for simulating the Weather Research and Forecasting (WRF) model are 12-km CONUS input.
These are used to run the WRF executable (wrf.exe) to simulate atmospheric events that took place during the Pre-Thanksgiving Winter Storm of 2019.
The model domain includes the entire Continental United States (CONUS), using 12-km grid spacing, which means that each grid point is 12x12 km.
The full domain contains 425 x 300 grid points. After running the WRF model, post-processing will allow visualization of atmospheric variables available in the output (e.g., temperature, wind speed, pressure). 

On the HPC Cluster, download the CONUS 12km test case from the [NCAR/MMM website](https://www2.mmm.ucar.edu/wrf/users/) into the **/shared** directory.
**/shared** is the mount point of NFS server hosted on the head node.

Here are the steps:

```bash
cd /shared
curl -O https://www2.mmm.ucar.edu/wrf/OnLineTutorial/wrf_cloud/wrf_simulation_CONUS12km.tar.gz
tar -xzf wrf_simulation_CONUS12km.tar.gz
```

#### Prepare the data
Next we'll prepare the data for a run by copying in the relevant files from our WRF install:

```bash
cd /shared/conus_12km/
WRF_ROOT=$(spack location -i wrf%intel)/test/em_real/
ln -s $WRF_ROOT* .
```

{{% notice note %}}
Please be aware there is a `namelist.input` in the current directory that you
do not want to overwrite. The link command will return the following
error, which is safe to ignore.
`ln: failed to create symbolic link ‘./namelist.input’: File exists`
{{% /notice %}}