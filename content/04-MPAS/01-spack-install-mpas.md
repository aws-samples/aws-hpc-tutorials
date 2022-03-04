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
spack install --cache-only --reuse -j \$SLURM_CPUS_ON_NODE mpas-model%intel^intel-oneapi-mpi+external-libfabric^parallelio+pnetcdf
EOF
```

* `-N 1` tells Slurm to allocate one instance
* `--exclusive` tells slurm to use all the cores on that instance
* `spack install --cache-only --reuse -j $SLURM_CPUS_ON_NODE mpas%intel^intel-oneapi-mpi+external-libfabric^parallelio+pnetcdf` This tells Spack to install [MPAS](https://spack.readthedocs.io/en/latest/package_list.html#mpas-model) using the latest version in the [Spack recipe](https://github.com/spack/spack/blob/develop/var/spack/repos/builtin/packages/mpas-model/package.py). It passes some build flags:

| **Spack Flag**   | **Description** |
| ----------- | ----------- |
| `--cache-only` | Only install packages from binary mirrors. |
| `--reuse`   | [Reuse](https://spack.readthedocs.io/en/latest/basic_usage.html#reusing-installed-dependencies) installed dependencies. |
| `-j $SLURM_CPUS_ON_NODE`     | Compile with all cores on the instance.   |
| `%intel`     | Specify the [Intel Compiler (icc)](https://spack.readthedocs.io/en/latest/package_list.html#intel-oneapi-compilers) we installed in [e. Install Intel Compilers](/02-cluster/06-install-intel-compilers.html#intel_compilers). |
| `^intel-onapi-mpi+external-libfabric` | Uses Intel MPI which we added in [e. Install Intel MPI](/02-cluster/06-install-intel-compilers.html#intel_mpi)
| `^parallelio+pnetcdf` | Build and use [Parallel IO](https://ncar.github.io/ParallelIO/) with [PnetCDF](https://parallel-netcdf.github.io/) support |

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

This will take about **3 minutes** to install. While that's installing feel free to advance to the [next step](/04-mpas/02-supercell.html) and pull down the supercell test case.
