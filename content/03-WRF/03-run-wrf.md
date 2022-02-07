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

spack load wrf@4.3.3%intel build_type=dm+sm ^intel-mpi
set -x
wrf_exe=\$(spack location -i wrf@4.3.3%intel build_type=dm+sm ^intel-mpi)/run/wrf.exe
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

Submit the job:

```bash
sbatch slurm-wrf-conus12km.sh
```

Monitor the job's status with `squeue`:

```bash
squeue
```

Using 192 cores, the job took **4 mins 17 seconds** to complete.
