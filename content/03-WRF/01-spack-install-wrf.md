---
title: "a. Install WRF"
weight: 31
tags: ["tutorial", "pcluster-manager", "ParallelCluster", "Spack"]
---

Now that we've built a cluster, let's install WRF:

{{% notice note %}}
We're going to install WRF via a Slurm job on a compute node, this ensures the architecture that we compile the code on matches the architecture it'll run on, it also allows us to use all the cores on a single instance to speedup the install:
{{% /notice %}}

```bash
cat <<EOF > wrf-install.sbatch
#!/bin/bash
#SBATCH -N 1
#SBATCH --exclusive

echo "Installing WRF on \$SLURM_CPUS_ON_NODE cores."
spack install -j \$SLURM_CPUS_ON_NODE wrf@4.3.3%intel build_type=dm+sm ^intel-oneapi-mpi+external-libfabric
EOF
```

* `-N 1` tells Slurm to allocate one instance
* `--exclusive` tells slurm to use all the cores on that instance
* `spack install -j $SLURM_CPUS_ON_NODE wrf%intel build_type=dm+sm ^intel-oneapi-mpi+external-libfabric` This tells Spack to install [WRF](https://spack.readthedocs.io/en/latest/package_list.html#wrf) using the latest version in the [Spack recipe](https://github.com/spack/spack/blob/develop/var/spack/repos/builtin/packages/wrf/package.py). It passes some build flags:

| **Spack Flag**   | **Description** |
| ----------- | ----------- |
| `-j $SLURM_CPUS_ON_NODE`     | Compile with all the cores on the instance.   |
| `@4.3.3`    | Specify version [4.3.3](https://github.com/wrf-model/WRF/releases/tag/v4.3.3) of WRF. |
| `%intel`     | Specify the [Intel Compiler (icc)](https://spack.readthedocs.io/en/latest/package_list.html#intel-oneapi-compilers) we installed in [e. Install Intel Compilers](/02-cluster/06-install-intel-compilers.html#intel_compilers). |
| `build_type=dm+sm`       | Enable [hybrid parallelism](https://in.nau.edu/hpc/overview/using-the-cluster-advanced/parallelism/) MPI + OpenMP.     |
| `^intel-oneapi-mpi+external-libfabric`    | Uses Intel MPI which we added in [e. Install Intel MPI](/02-cluster/06-install-intel-compilers.html#intel_mpi).   |

Submit the job:

```bash
sbatch wrf-install.sbatch
```

Watch **squeue** to see when the job transitions from `CF` (bootstrapping) into `R` (running).

```bash
squeue
```

Monitor the install by tailing the job output file, i.e. if we submitted a job with id 1 that's:

```bash
tail -f slurm-1.out
```

This will take about **5 minutes** to install. While that's installing feel free to advance to the [next step](/03-wrf/02-conus-12km.html) and pull down the Conus 12-km model.
