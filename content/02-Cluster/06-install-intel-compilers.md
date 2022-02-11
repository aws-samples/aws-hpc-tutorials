---
title: "e. Install Intel Compilers & MPI"
weight: 26
tags: ["tutorial", "pcluster-manager", "ParallelCluster", "Spack"]
---

## Intel Compilers {#intel_compilers}

Next we'll use Spack to install the [Intel Compilers (ICC)](https://www.intel.com/content/www/us/en/developer/tools/oneapi/toolkits.html), we'll use these to compile binaries such as WRF in the next few sections:

```bash
spack install intel-oneapi-compilers
```

This will take about `~4 mins` to complete. Once it's complete we can load the compiler:

```bash
spack load intel-oneapi-compilers
spack compiler find
spack unload
```

This will display the Intel compiler under:

```bash
spack compilers
```

![Spack Compilers](/images/pcluster/spack-compilers.png)

## Intel MPI {#intel_mpi}

We will now install the [Intel MPI library](https://www.intel.com/content/www/us/en/developer/tools/oneapi/mpi-library.html) underneath the Intel compilers.
We are also going to use the AWS [EFA](https://aws.amazon.com/hpc/efa/) libfabric. We told Spack this was already installed in the [previous step](05-external-packages.html).

```bash
spack install intel-oneapi-mpi+external-libfabric%intel
```

This will take less than a minute to complete.
