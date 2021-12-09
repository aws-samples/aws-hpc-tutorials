---
title: "a. Install WRF"
weight: 31
tags: ["tutorial", "pcluster-manager", "ParallelCluster", "Spack"]
---

Now that we've built a cluster, let's install WRF:

**Note** we're going to install WRF via a Slurm job on a compute node, this ensures the architecture that we compile the code on matches the architecture it'll run on, it also allows us to use all the cores on a single instance to speedup the install:

```bash
cat <<EOF > wrf.sbatch
#!/bin/bash
#SBATCH -N 1
#SBATCH --exclusive

echo "Installing WRF on \$SLURM_CPUS_ON_NODE cores."
spack install -j \$SLURM_CPUS_ON_NODE wrf%intel
EOF
```

Submit the job:

```bash
sbatch wrf.sbatch
```

Watch **squeue** to see when the job transitions from `CF` (bootstrapping) into `R` (running).

```bash
squeue
```

Monitor the install by tailing the job output file, i.e. if we submitted a job with id 2 that's:

```bash
tail -f slurm-2.out
```

While that's installing feel free to advance to the [next step](/03-wrf/02-conus-12km.html) and pull down the Conus 12-km model.