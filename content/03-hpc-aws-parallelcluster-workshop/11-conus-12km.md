+++
title = "l. CONUS 12-km Model"
date = 2023-04-10T10:46:30-04:00
weight = 100
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
curl -O https://isc-hpc-labs.s3.amazonaws.com/wrf_simulation_CONUS12km.tar.gz

tar -xzf wrf_simulation_CONUS12km.tar.gz 
```
For the purpose of ISC23, a copy of the data that can be found on UCAR website through this [link](https://www2.mmm.ucar.edu/wrf/OnLineTutorial/wrf_cloud/wrf_simulation_CONUS12km.tar.gz) has been stored in a S3 bucket.

#### Prepare the data
Copy the necessary files for running the CONUS 12km test case from the run directory of the WRF source code.
A copy of the WRF source code is part of the AMI and located  in __/opt/wrf-omp/src__.

```bash
cd /shared/conus_12km

cp /opt/wrf-omp/src/run/{\
GENPARM.TBL,\
HLC.TBL,\
LANDUSE.TBL,\
MPTABLE.TBL,\
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

#### Run the CONUS 12Km simulation
In this step, you create the SLURM batch script that will run the WRF CONUS 12km test case on 72 cores distributed over 2 x c5n.18xlarge EC2 instances.

```bash
cat > slurm-c5n-wrf-conus12km.sh << EOF
#!/bin/bash

#SBATCH --job-name=WRF-CONUS12km
#SBATCH --partition=queue0
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err
#SBATCH --ntasks=72
#SBATCH --constraint=c5n.18xlarge


export I_MPI_OFI_LIBRARY_INTERNAL=0
export I_MPI_OFI_PROVIDER=efa

module purge
module load wrf-omp/4.2.2-intel-2021.3.0

mpirun wrf.exe
EOF
```