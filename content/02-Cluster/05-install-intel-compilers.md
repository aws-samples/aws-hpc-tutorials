---
title: "e. Install Intel Compilers"
weight: 25
tags: ["tutorial", "pcluster-manager", "ParallelCluster", "Spack"]
---

Next we'll use Spack to install the [Intel Compilers (ICC)](https://www.intel.com/content/www/us/en/developer/tools/oneapi/toolkits.html), we'll use these to compile binaries such as WRF in the next few sections:

```bash
spack install intel-oneapi-compilers
```

This will take about `~4 mins` to complete. Once it's complete we can load the compiler:

```bash
spack install intel-oneapi-compilers intel-oneapi-mpi
spack load intel-oneapi-compilers
spack compiler find
spack unload
```

This will display the intel compiler under:

```bash
spack compilers
```