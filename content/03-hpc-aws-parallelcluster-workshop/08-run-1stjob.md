+++
title = "f. Submit a tightly coupled HPC job"
date = 2019-09-18T10:46:30-04:00
weight = 90
tags = ["tutorial", "create", "ParallelCluster"]
+++

{{% notice note %}}
The steps here can also be executed on any cluster running SLURM. There may be some variations depending on your configuration.
{{% /notice %}}

In this lab, you run the WRF [CONUS 12km test case](https://www2.mmm.ucar.edu/wrf/users/benchmark/benchdata_v422.html) job to introduce you to the mechanisms of AWS ParallelCluster.

#### About WRF
The Weather Research and Forecasting (WRF) Model is a next-generation mesoscale numerical weather prediction system designed for both atmospheric research and operational forecasting applications.
It features a dynamical core, a data assimilation system, and a software architecture supporting parallel computation and system extensibility.
The model serves a wide range of meteorological applications across scales from tens of meters to thousands of kilometers.
The effort to develop WRF began in the latter 1990's and was a collaborative partnership of the National Center for Atmospheric Research (NCAR), the National Oceanic and Atmospheric Administration (represented by the National Centers for Environmental Prediction (NCEP) and the Earth System Research Laboratory), the U.S. Air Force, the Naval Research Laboratory, the University of Oklahoma, and the Federal Aviation Administration (FAA).

WRF is a tightly coupled application that uses MPI and/or OpenMP.
In this lab, you will run WRF using only MPI.

#### Preparatory Steps

{{% notice info %}}
Make sure that you are logged into the AWS ParallelCluster head node through the AWS Cloud9 terminal.
{{% /notice %}}


#### Download CONUS 12KM
Input data used for simulating the Weather Research and Forecasting (WRF) model are 12-km CONUS input.
These are used to run the WRF executable (wrf.exe) to simulate atmospheric events that took place during the Pre-Thanksgiving Winter Storm of 2019.
The model domain includes the entire Continental United States (CONUS), using 12-km grid spacing, which means that each grid point is 12x12 km.
The full domain contains 425 x 300 grid points. After running the WRF model, post-processing will allow visualization of atmospheric variables available in the output (e.g., temperature, wind speed, pressure). 

On the HPC Cluster, download the CONUS 12km test case from the [NCAR/MMM website](https://www2.mmm.ucar.edu/wrf/users/) into the **/fsx** directory.
**/fsx** is the mount point of the high performance file system, [Amazon FSx for Lustre](https://aws.amazon.com/fsx/lustre/).

Here are the steps:

```bash
cd /fsx
curl -O https://www2.mmm.ucar.edu/wrf/OnLineTutorial/wrf_cloud/wrf_simulation_CONUS12km.tar.gz 
tar -xzf wrf_simulation_CONUS12km.tar.gz 
```

#### Prepare the data
Copy the necessary files for running the CONUS 12km test case from the run directory of the WRF source code.
A copy of the WRF source code is part of the AMI and located  in __/opt/wrf-omp/src__.

```bash
cd /fsx/conus_12km

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
#SBATCH --partition=c5n18large
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err
#SBATCH --ntasks=72
#SBATCH --ntasks-per-node 36
#SBATCH --cpus-per-task=1


export I_MPI_OFI_LIBRARY_INTERNAL=0
export I_MPI_OFI_PROVIDER=efa

module purge
module load wrf-omp/4.2.2-intel-2021.3.0

mpirun wrf.exe
EOF
```

#### Submit your First Job

Submitted jobs are immediately processed if the job is in the queue and a sufficient number of compute nodes exist.

If there are not enough compute nodes to satisfy the computational requirements of the job, such as the number of cores, AWS ParallelCluster creates new instances to satisfy the requirements of the jobs sitting in the queue. However, note that you determined the minimum and maximum number of nodes when you created the cluster. If the maximum number of nodes is reached, no additional instances will be created.

Submit your first job using the following command on the head node:

```bash
sbatch slurm-c5n-wrf-conus12km.sh
```

Check the status of the queue using the command **squeue**. The job will be first marked as pending (*PD* state) because resources are being created (or in a down/drained state). If you check the [EC2 Dashboard](https://console.aws.amazon.com/ec2), you should see nodes booting up.

```bash
squeue 
```
When ready and registered, your job will be processed and you will see a similar status as below.
![squeue output](/images/hpc-aws-parallelcluster-workshop/squeue-output.png)

You can also check the number of nodes available in your cluster using the command **sinfo**. Do not hesitate to refresh it, nodes generally take less than 5 min to appear.

```bash
sinfo
```
 The following example shows 4 nodes.
![squeue output](/images/hpc-aws-parallelcluster-workshop/sinfo-output.png)

Once the job has been processed, you should see similar results as follows in one of the rsl.out.* files:

Look for "SUCCESS COMPLETE WRF" at the end of the rsl* file.

![squeue output](/images/hpc-aws-parallelcluster-workshop/helloworld-output.png)


Done!

After a few minutes, your cluster will scale down unless there are more job to process.


Exit the HPC Cluster
```bash
exit
```
