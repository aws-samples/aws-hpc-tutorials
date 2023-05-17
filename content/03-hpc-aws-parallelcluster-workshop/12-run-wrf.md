+++
title = "k. Run WRF"
date = 2023-04-10T10:46:30-04:00
weight = 120
tags = ["tutorial", "create", "ParallelCluster"]
+++

#### Submit your First Job: the CONUS 12Km simulation

In this step, you create the Slurm batch script that will run the WRF CONUS 12km test case on 36 cores distributed over 2 x c5n.18xlarge EC2 instances.

```bash
cat > slurm-wrf-conus12km.sh << EOF
#!/bin/bash
#SBATCH --job-name=WRF
#SBATCH --partition=compute
#SBATCH --output=conus-%j.out
#SBATCH --error=conus-%j.err
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=6
#SBATCH --exclusive
export I_MPI_OFI_LIBRARY_INTERNAL=0

module purge
module load wrf-omp/4.2.2-intel-2022.2.0

wrf_exe=wrf.exe
set -x
ulimit -s unlimited
ulimit -a
export OMP_NUM_THREADS=6
export FI_PROVIDER=efa
export I_MPI_FABRICS=ofi
export I_MPI_OFI_PROVIDER=efa
export I_MPI_PIN_DOMAIN=omp
export KMP_AFFINITY=compact
export I_MPI_DEBUG=4
time mpiexec.hydra -np \$SLURM_NTASKS --ppn \$SLURM_NTASKS_PER_NODE \$wrf_exe
EOF
```

In the above job script we've set environment variables to ensure that Intel MPI and OpenMP are pinned to the correct cores and [EFA is enabled](https://aws.amazon.com/hpc/efa/). The variables used will be explained shortly, but first submit the job using the following command from the head node:
 
```bash
sbatch slurm-wrf-conus12km.sh
```

Submitted jobs are immediately processed if the job is in the queue and a sufficient number of compute nodes exist.

If there are not enough compute nodes to satisfy the computational requirements of the job, such as the number of cores, AWS ParallelCluster creates new instances to satisfy the requirements of the jobs sitting in the queue. However, note that you determined the minimum and maximum number of nodes when you created the cluster. If the maximum number of nodes is reached, no additional instances will be created.

This job used the following environment variables to prepare the job:

| Environment Variable                 | Value                                                                                                                                                                                                                                                                                                                                                 |
|------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [OMP_NUM_THREADS=6](https://www.openmp.org/spec-html/5.0/openmpse50.html)           | Number of OpenMP threads. We're using 12 MPI procs (6 per instance), each with 6 OMP threads to use all 16 x 6 = 72 cores.                                                                                                                                                                                                                                             |
| [FI_PROVIDER=efa](https://www.intel.com/content/www/us/en/developer/articles/technical/mpi-library-2019-over-libfabric.html#inpage-nav-3)             | Enable EFA. This tells [libfabric](https://ofiwg.github.io/libfabric/) to use the EFA fabric.                                                                                                                                                                                                                                                                                               |
| [I_MPI_FABRICS=ofi](https://www.intel.com/content/www/us/en/develop/documentation/mpi-developer-reference-linux/top/environment-variable-reference/environment-variables-for-fabrics-control/communication-fabrics-control.html)            | This tells Intel MPI to use libfabric.                                                                                                                                                                                                                                                                                                                |
| [I_MPI_OFI_LIBRARY_INTERNAL=0](https://www.intel.com/content/www/us/en/develop/documentation/mpi-developer-reference-linux/top/environment-variable-reference/environment-variables-for-fabrics-control/ofi-capable-network-fabrics-control.html) | This tells Intel MPI to use the version of libfabric packaged on the OS and not the one built into impi.                                                                                                                                                                                                                                              |
| [I_MPI_OFI_PROVIDER=efa](https://www.intel.com/content/www/us/en/develop/documentation/mpi-developer-reference-linux/top/environment-variable-reference/environment-variables-for-fabrics-control/ofi-capable-network-fabrics-control.html)      | This tells Intel MPI to use the libfabric efa provider.                                                                                                                                                                                                                                                                                               |
| [I_MPI_PIN_DOMAIN=omp](https://www.intel.com/content/www/us/en/develop/documentation/mpi-developer-reference-linux/top/environment-variable-reference/process-pinning/interoperability-with-openmp-api.html)      | The domain size is equal to `OMP_NUM_THREADS`, this ensures that each MPI rank is associated with it's own non-overlapping domain. |
| [KMP_AFFINITY=compact](https://www.intel.com/content/www/us/en/develop/documentation/cpp-compiler-developer-guide-and-reference/top/optimization-and-programming-guide/openmp-support/openmp-library-support/thread-affinity-interface-linux-and-windows.html)         | Specifying compact assigns the OpenMP thread N+1 to a free thread context as close as possible to the thread context where the N OpenMP thread was placed.                                                                                                                                                                                        |
| [I_MPI_DEBUG=4](https://www.intel.com/content/www/us/en/develop/documentation/mpi-developer-reference-linux/top/environment-variable-reference/other-environment-variables.html)                | Debugging info including process pinning information.                                                                                                                                                                                                                     


Check the status of the queue using the command **squeue**. The job will be first marked as pending (*PD* state) because resources are being created (or in a down/drained state). If you check the [EC2 Dashboard](https://console.aws.amazon.com/ec2), you should see nodes booting up.

```bash
squeue 
```
When ready and registered, your job will be processed and you will see a similar status as below.
![squeue output](/images/hpc-aws-parallelcluster-workshop/squeue-output.png)

You can also check the number of nodes available in your cluster using the command **sinfo**. Nodes generally take less than 5 min to appear.

```bash
sinfo
```
 The following example shows 2 nodes.
 ```bash
[ec2-user@ip-172-31-0-4 conus_12km]$ sinfo
PARTITION AVAIL  TIMELIMIT  NODES  STATE NODELIST
compute*     up   infinite      1 alloc# compute-dy-compute-1
compute*     up   infinite      1  idle~ compute-dy-compute-2
```


The job takes around 7 minutes to complete. Once the job has been processed, you should see similar results as follows in the rsl.out.0000 file:

```bash
[ec2-user@ip-172-31-0-4 conus_12km-2]$ tail -10 rsl.out.0000
Timing for main: time 2019-11-26_17:51:36 on domain   1:    0.33458 elapsed seconds
Timing for main: time 2019-11-26_17:52:48 on domain   1:    0.33379 elapsed seconds
Timing for main: time 2019-11-26_17:54:00 on domain   1:    0.33362 elapsed seconds
Timing for main: time 2019-11-26_17:55:12 on domain   1:    0.34980 elapsed seconds
Timing for main: time 2019-11-26_17:56:24 on domain   1:    0.33455 elapsed seconds
Timing for main: time 2019-11-26_17:57:36 on domain   1:    0.33491 elapsed seconds
Timing for main: time 2019-11-26_17:58:48 on domain   1:    0.33329 elapsed seconds
Timing for main: time 2019-11-26_18:00:00 on domain   1:    0.33406 elapsed seconds
Timing for Writing wrfout_d01_2019-11-26_18:00:00 for domain        1:    9.79488 elapsed seconds
wrf: SUCCESS COMPLETE WRF
```

Look for "SUCCESS COMPLETE WRF" at the end of the rsl file.

After a few minutes, your cluster will scale down unless there are more job to process.
