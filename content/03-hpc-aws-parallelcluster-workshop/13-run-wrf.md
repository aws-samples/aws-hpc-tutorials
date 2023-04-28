+++
title = "m. Run WRF"
date = 2023-04-10T10:46:30-04:00
weight = 120
tags = ["tutorial", "create", "ParallelCluster"]
+++

#### Submit your First Job

Create a Slurm sbatch script to run the CONUS 12-km model:

```bash
cd /shared/conus_12km/
cat > slurm-wrf-conus12km.sh << EOF
#!/bin/bash
#SBATCH --job-name=WRF
#SBATCH --output=conus-%j.out
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=16
#SBATCH --exclusive
export I_MPI_OFI_LIBRARY_INTERNAL=0
spack load intel-oneapi-mpi
spack load wrf
module load libfabric-aws
wrf_exe=\$(spack location -i wrf)/run/wrf.exe
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

In the above job script we've set environment variables to ensure that Intel MPI and OpenMP are pinned to the correct cores and [EFA is enabled](https://www.hpcworkshops.com/07-efa.html). See

| Environment Variable                 | Value                                                                                                                                                                                                                                                                                                                                                 |
|------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [OMP_NUM_THREADS=6](https://www.openmp.org/spec-html/5.0/openmpse50.html)           | Number of OpenMP threads. We're using 16 MPI procs, each with 6 OMP threads to use all 16 x 6 = 96 cores.                                                                                                                                                                                                                                             |
| [FI_PROVIDER=efa](https://www.intel.com/content/www/us/en/developer/articles/technical/mpi-library-2019-over-libfabric.html#inpage-nav-3)             | Enable EFA. This tells [libfabric](https://ofiwg.github.io/libfabric/) to use the EFA fabric.                                                                                                                                                                                                                                                                                               |
| [I_MPI_FABRICS=ofi](https://www.intel.com/content/www/us/en/develop/documentation/mpi-developer-reference-linux/top/environment-variable-reference/environment-variables-for-fabrics-control/communication-fabrics-control.html)            | This tells Intel MPI to use libfabric.                                                                                                                                                                                                                                                                                                                |
| [I_MPI_OFI_LIBRARY_INTERNAL=0](https://www.intel.com/content/www/us/en/develop/documentation/mpi-developer-reference-linux/top/environment-variable-reference/environment-variables-for-fabrics-control/ofi-capable-network-fabrics-control.html) | This tells Intel MPI to use the version of libfabric packaged on the OS and not the one built into impi.                                                                                                                                                                                                                                              |
| [I_MPI_OFI_PROVIDER=efa](https://www.intel.com/content/www/us/en/develop/documentation/mpi-developer-reference-linux/top/environment-variable-reference/environment-variables-for-fabrics-control/ofi-capable-network-fabrics-control.html)      | This tells Intel MPI to use the libfabric efa provider.                                                                                                                                                                                                                                                                                               |
| [I_MPI_PIN_DOMAIN=omp](https://www.intel.com/content/www/us/en/develop/documentation/mpi-developer-reference-linux/top/environment-variable-reference/process-pinning/interoperability-with-openmp-api.html)      | The domain size is equal to `OMP_NUM_THREADS`, this ensures that each MPI rank is associated with it's own non-overlapping domain. |
| [KMP_AFFINITY=compact](https://www.intel.com/content/www/us/en/develop/documentation/cpp-compiler-developer-guide-and-reference/top/optimization-and-programming-guide/openmp-support/openmp-library-support/thread-affinity-interface-linux-and-windows.html)         | Specifying compact assigns the OpenMP thread N+1 to a free thread context as close as possible to the thread context where the N OpenMP thread was placed.                                                                                                                                                                                        |
| [I_MPI_DEBUG=4](https://www.intel.com/content/www/us/en/develop/documentation/mpi-developer-reference-linux/top/environment-variable-reference/other-environment-variables.html)                | Debugging info including process pinning information.                                                                                                                                                                                                                     

Submitted jobs are immediately processed if the job is in the queue and a sufficient number of compute nodes exist.

If there are not enough compute nodes to satisfy the computational requirements of the job, such as the number of cores, AWS ParallelCluster creates new instances to satisfy the requirements of the jobs sitting in the queue. However, note that you determined the minimum and maximum number of nodes when you created the cluster. If the maximum number of nodes is reached, no additional instances will be created.

Submit your first job using the following command on the head node:

```bash
sbatch slurm-wrf-conus12km.sh
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
 The following example shows 2 nodes.
![squeue output](/images/hpc-aws-parallelcluster-workshop/sinfo-output.png)

Once the job has been processed, you should see similar results as follows in one of the rsl.out.* files:

Look for "SUCCESS COMPLETE WRF" at the end of the rsl* file.

![squeue output](/images/hpc-aws-parallelcluster-workshop/helloworld-output.png)


Using 192 cores, the job took **4 mins 17 seconds** to complete.

Done!

After a few minutes, your cluster will scale down unless there are more job to process.
