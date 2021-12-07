---
title: "a. Install WRF"
weight: 31
tags: ["tutorial", "pcluster-manager", "ParallelCluster", "Spack"]
---

Now that we've built a cluster, let's install WRF:

**Note** we're going to install via a slurm job on a compute node, this ensures the architecture that we compile the code on matches the architecture it'll run on, it also allows us to use all the cores on a single instance to speedup the install:

```bash
cat <<EOF > wrf.sbatch
#!/bin/bash
#SBATCH -N 1
#SBATCH --exclusive

echo "Installing WRF on $SLURM_CPUS_ON_NODE cores."
spack install -j \$SLURM_CPUS_ON_NODE wrf
EOF
```

Submit the job:

```bash
sbatch wrf.sbatch
```

Monitor the install by tailing the job output file, i.e. if we submitted a job with id 2 that's:

```bash
tail -f slurm-2.out
```