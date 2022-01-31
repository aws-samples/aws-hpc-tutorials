---
title: "a. Install MPAS"
weight: 41
tags: ["tutorial", "pcluster-manager", "ParallelCluster", "Spack"]
---

Now that we've built a cluster, let's install MPAS:

**Note** we're going to install MPAS via a Slurm job on a compute node, this ensures the architecture that we compile the code on matches the architecture it'll run on, it also allows us to use all the cores on a single instance to speedup the install:

```bash
srun -N 1 --exclusive --ntasks-per-node 4 spack install -j 24 mpas-model%intel^intel-oneapi-mpi
```

* `-N 1` tells Slurm to allocate one instance
* `--exclusive` tells slurm to use all the cores on that instance
* `-ntasks-per-node 4` tells Slurm to run 4 tasks on the instance
* `spack install -j 24 mpas%intel^intel-oneapi-mpi` This tells Spack to install [MPAS](https://spack.readthedocs.io/en/latest/package_list.html#mpas-model) using the latest version in the [Spack recipe](https://github.com/spack/spack/blob/develop/var/spack/repos/builtin/packages/mpas-model/package.py). It passes some build flags:

| **Spack Flag**   | **Description** |
| ----------- | ----------- |
| `-j 24`     | Compile with 24 cores on the instance.   |
| `%intel`     | Specify the [Intel Compiler (icc)](https://spack.readthedocs.io/en/latest/package_list.html#intel-oneapi-compilers) we installed in [e. Install Intel Compilers](/02-cluster/05-install-intel-compilers.html). |
| `^intel-oneapi-mpi`     | Uses Intel MPI which we added in [f. Spack external packages](/02-cluster/05-install-intel-compilers.html)


This will take about **25 minutes** to install. While that's installing feel free to advance to the [next step](/04-MPAS/02-supercell.html) and pull down the supercell test case.
