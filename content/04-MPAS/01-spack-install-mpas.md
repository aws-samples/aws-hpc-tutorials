---
title: "a. Install MPAS"
weight: 41
tags: ["tutorial", "pcluster-manager", "ParallelCluster", "Spack"]
---

Now that we've built a cluster, let's install MPAS:

{{% notice note %}}
We're going to install MPAS via a Slurm job on a compute node, this ensures the architecture that we compile the code on matches the architecture it'll run on, it also allows us to use all the cores on a single instance to speedup the install:
{{% /notice %}}

```bash
cat > mpas-install.sh <<EOF
#!/bin/bash
#SBATCH -N 1
#SBATCH --exclusive

echo "Installing MPAS on \$SLURM_CPUS_ON_NODE cores."
spack install -j $SLURM_CPUS_ON_NODE mpas-model%intel^intel-mpi^parallelio+pnetcdf
EOF
```

* `-N 1` tells Slurm to allocate one instance
* `--exclusive` tells slurm to use all the cores on that instance
* `spack install -j $SLURM_CPUS_ON_NODE mpas%intel^intel-mpi^parallelio+pnetcdf` This tells Spack to install [MPAS](https://spack.readthedocs.io/en/latest/package_list.html#mpas-model) using the latest version in the [Spack recipe](https://github.com/spack/spack/blob/develop/var/spack/repos/builtin/packages/mpas-model/package.py). It passes some build flags:

| **Spack Flag**   | **Description** |
| ----------- | ----------- |
| `-j $SLURM_CPUS_ON_NODE`     | Compile with all cores on the instance.   |
| `%intel`     | Specify the [Intel Compiler (icc)](https://spack.readthedocs.io/en/latest/package_list.html#intel-oneapi-compilers) we installed in [e. Install Intel Compilers](/02-cluster/05-install-intel-compilers.html). |
| `^intel-mpi`     | Uses Intel MPI which we added in [f. Spack external packages](/02-cluster/05-install-intel-compilers.html)
| `^parallelio+pnetcdf` | Build and use [Parallel IO](https://ncar.github.io/ParallelIO/) with (parallel netcdf)[https://parallel-netcdf.github.io/] support |

Submit the job:

```bash
sbatch mpas-install.sh
```

Watch **squeue** to see when the job transitions from `CF` (bootstrapping) into `R` (running).

```bash
squeue
```

Monitor the install by tailing the job output file, i.e. if we submitted a job with id 5 that's:

```bash
tail -f slurm-5.out
```

This will take about **25 minutes** to install. While that's installing feel free to advance to the [next step](/04-mpas/02-supercell.html) and pull down the supercell test case.
