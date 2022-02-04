---
title: "c. Run WRF"
weight: 33
tags: ["tutorial", "pcluster-manager", "ParallelCluster", "Spack"]
---

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

spack load wrf%intel build_type=dm+sm ^intel-mpi
set -x
wrf_exe=\$(spack location -i wrf%intel build_type=dm+sm ^intel-mpi)/run/wrf.exe
ulimit -s unlimited
ulimit -a

export OMP_NUM_THREADS=6
export FI_PROVIDER=efa
export I_MPI_FABRICS=ofi
export I_MPI_OFI_LIBRARY_INTERNAL=0
export I_MPI_OFI_PROVIDER=efa
export I_MPI_PIN_DOMAIN=omp
export KMP_AFFINITY=compact
export I_MPI_DEBUG=4

set +x
module load intelmpi
set -x
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
| [I_MPI_DEBUG=4](https://www.intel.com/content/www/us/en/develop/documentation/mpi-developer-reference-linux/top/environment-variable-reference/other-environment-variables.html)                | Debugging info including process pinning information.                                                                                                                                                                                                                                                                                |

Submit the job:

```bash
sbatch slurm-wrf-conus12km.sh
```

Monitor the job's status with `squeue`:

```bash
squeue
```

Using 192 cores, the job took **4 mins 17 seconds** to complete.
