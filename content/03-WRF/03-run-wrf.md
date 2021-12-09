---
title: "c. Run WRF"
weight: 33
tags: ["tutorial", "pcluster-manager", "ParallelCluster", "Spack"]
---

Create a Slurm sbatch script to run the CONUS 12-km model:

**Note** We set the number of processes per node with **ntasks-per-node = 6** and the number of OpenMP threads with **OMP_NUM_THREADS = 6**. When combined `6 * 16 = 96`, we get 96 threads. This should match the total number of cores on a single instance.

```bash
cd /shared/conus_12km/
cat > slurm-wrf-conus12km.sh << EOF
#!/bin/bash

#SBATCH --job-name=WRF
#SBATCH --output=conus-%j.out
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=16
#SBATCH --exclusive

spack load wrf%intel
set -x
wrf_exe=\$(spack location -i wrf%intel)/run/wrf.exe
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

time mpiexec.hydra -np \$SLURM_NTASKS --ppn \$SLURM_NTASKS_PER_NODE \$wrf_exe
EOF
```

Submit the job:

```bash
sbatch slurm-wrf-conus12km.sh
```

Monitor the job's status with `squeue`:

```bash
squeue
```