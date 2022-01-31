---
title: "e. Install Intel Compilers and MPI"
weight: 25
tags: ["tutorial", "pcluster-manager", "ParallelCluster", "Spack"]
---

Next we'll use Spack to install the [Intel Compilers (ICC)](https://www.intel.com/content/www/us/en/developer/tools/oneapi/toolkits.html) and MPI, we'll use these to compile binaries such as WRF in the next few sections:

```bash
spack install intel-oneapi-compilers
```

This will take about `~4 mins` to complete. Once it's complete we can load the compiler:

```bash
spack load intel-oneapi-compilers
spack compiler find
spack unload
```

This will display the intel compiler under:

```bash
spack compilers
```

![Spack Compilers](/images/pcluster/spack-compilers.png)

We now install the [Intel MPI](https://www.intel.com/content/www/us/en/developer/tools/oneapi/toolkits.html) library, explicitly using the Intel compiler underneath. This should take less than a minute to complete.

```bash
spack install intel-oneapi-mpi%intel
```

If you run `spack find`, you will see the Intel MPI underneath the Intel compiler section.

![Spack Find](/images/pcluster/spack-find-mpi.png)
