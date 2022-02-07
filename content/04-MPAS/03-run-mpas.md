---
title: "c. Run MPAS"
weight: 43
tags: ["tutorial", "pcluster-manager", "ParallelCluster", "Spack"]
---

Now that we've installed MPAS and created a domain decomposition graph for the number of MPI ranks we will use. We're able to run the forecast.
For the forecast there's two steps:

1. Create the initial conditions for the model.
2. Run the MPAS model to produce a forecast.

Create a Slurm sbatch script to run the supercell test case:

```bash
cd /shared/supercell/
cat > slurm-mpas-supercell.sh << EOF
#!/bin/bash

#SBATCH --job-name=MPAS
#SBATCH --output=supercell-%j.out
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=16
#SBATCH --exclusive

export I_MPI_OFI_LIBRARY_INTERNAL=0
spack load intel-oneapi-mpi
spack load mpas-model%intel^intel-oneapi-mpi
set -x
init_exe=\$(spack location -i mpas-model%intel^intel-oneapi-mpi)/bin/init_atmosphere_model
mpas_exe=\$(spack location -i mpas-model%intel^intel-oneapi-mpi)/bin/atmosphere_model
ulimit -s unlimited
ulimit -a

export FI_PROVIDER=efa
export I_MPI_DEBUG=4
export I_MPI_FABRICS=ofi
export I_MPI_OFI_PROVIDER=efa
export I_MPI_PIN_DOMAIN=omp
export KMP_AFFINITY=compact
export OMP_NUM_THREADS=6

# create initial conditions
time mpiexec.hydra -np \$SLURM_NTASKS --ppn \$SLURM_NTASKS_PER_NODE \$init_exe

# run the model
time mpiexec.hydra -np \$SLURM_NTASKS --ppn \$SLURM_NTASKS_PER_NODE \$mpas_exe
EOF
```

Submit the job:

```bash
sbatch slurm-mpas-supercell.sh
```

Monitor the job's status with `squeue`:

```bash
squeue
```

Using 192 cores, the job took **4 mins 17 seconds** to complete.
