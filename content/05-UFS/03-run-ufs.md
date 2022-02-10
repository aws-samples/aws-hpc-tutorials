---
title: "c. Run UFS"
weight: 53
tags: ["tutorial", "pcluster-manager", "ParallelCluster", "Spack"]
---

Now that we've installed UFS and extracted the test case. We're able to run the forecast.

Create a Slurm sbatch script to run the test case:

```bash
cd /shared/simple-test-case/
cat > slurm-ufs.sh << EOF
#!/bin/bash

#SBATCH --chdir=/shared/simple-test-case/
#SBATCH --job-name=UFS
#SBATCH --output=slurm-ufs-%j.out
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=16
#SBATCH --exclusive

export I_MPI_OFI_LIBRARY_INTERNAL=0
spack load intel-oneapi-mpi
spack load ufs-weather-model
set -x
ulimit -s unlimited
ulimit -a

export FI_PROVIDER=efa
export I_MPI_DEBUG=4
export I_MPI_FABRICS=ofi
export I_MPI_OFI_PROVIDER=efa
export I_MPI_PIN_DOMAIN=omp
export KMP_AFFINITY=compact
export OMP_NUM_THREADS=6

# run the model
time mpiexec.hydra -np \$SLURM_NTASKS --ppn \$SLURM_NTASKS_PER_NODE ufs_weather_model
EOF
```

Submit the job:

```bash
sbatch slurm-ufs.sh
```

Monitor the job's status with `squeue`:

```bash
squeue
```

Using 192 cores, the job took **1 mins 56 seconds** to complete.
