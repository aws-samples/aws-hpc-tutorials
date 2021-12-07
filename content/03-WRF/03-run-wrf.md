---
title: "c. Run WRF"
weight: 33
tags: ["tutorial", "pcluster-manager", "ParallelCluster", "Spack"]
---

Create a Slurm sbatch script to run the CONUS 12-km model:

```bash
cd /shared
cat > slurm-wrf-conus12km.sh << EOF
#!/bin/bash

#SBATCH --job-name=WRF-CONUS12km
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err
#SBATCH --ntasks=96

spack load wrf
spack cd -i wrf
cd test/em_real
mpirun -np 96 ../../main/wrf.exe
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