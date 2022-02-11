---
title: "a. Install UFS"
weight: 51
tags: ["tutorial", "pcluster-manager", "ParallelCluster", "Spack"]
---

Now that we've built a cluster, let's install UFS:

{{% notice note %}}
We're going to install UFS via a Slurm job on a compute node, this ensures the architecture that we compile the code on matches the architecture it'll run on, it also allows us to use all the cores on a single instance to speedup the install:
{{% /notice %}}

```bash
cat > ufs-install.sh <<EOF
#!/bin/bash
#SBATCH -N 1
#SBATCH --exclusive

echo "Installing ufs on \$SLURM_CPUS_ON_NODE cores."
spack install -j \$SLURM_CPUS_ON_NODE ufs-weather-model%intel^intel-mpi
EOF
```

* `-N 1` tells Slurm to allocate one instance
* `--exclusive` tells slurm to use all the cores on that instance
* `spack install -j $SLURM_CPUS_ON_NODE mpas%intel^intel-mpi` This tells Spack to install [UFS](https://spack.readthedocs.io/en/latest/package_list.html#ufs-weather-model) using the latest version in the [Spack recipe](https://github.com/spack/spack/blob/develop/var/spack/repos/builtin/packages/ufs-weather-model/package.py). It passes some build flags:

| **Spack Flag**   | **Description** |
| ----------- | ----------- |
| `-j $SLURM_CPUS_ON_NODE`     | Compile with all cores on the instance.   |
| `%intel`     | Specify the [Intel Compiler (icc)](https://spack.readthedocs.io/en/latest/package_list.html#intel-oneapi-compilers) we installed in [e. Install Intel Compilers](/02-cluster/05-install-intel-compilers.html). |
| `^intel-mpi`     | Uses Intel MPI which we added in [f. Spack external packages](/02-cluster/05-install-intel-compilers.html)

Submit the job:

```bash
sbatch ufs-install.sh
```

Watch **squeue** to see when the job transitions from `CF` (bootstrapping) into `R` (running).

```bash
squeue
```

Monitor the install by tailing the job output file, i.e. if we submitted a job with id 7 that's:

```bash
tail -f slurm-7.out
```

This will take about **52 minutes** to install. While that's installing feel free to advance to the [next step](/05-ufs/02-simple-test.html) and pull down the simple test case.
