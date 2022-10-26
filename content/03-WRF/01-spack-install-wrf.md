---
title: "a. Install WRF"
weight: 31
tags: ["tutorial", "pcluster-manager", "ParallelCluster", "Spack"]
---

Now that we've built a cluster, let's install WRF:

{{% notice note %}}
We're going to install WRF on the HeadNode, we're able to do this as the architecture of the HeadNode instance type, `c6a.2xlarge`, matches the compute ndoes. In most other cases it makes sense to install on compute nodes.
{{% /notice %}}

```bash
spack install -j $(nproc) wrf@4.3.3%intel build_type=dm+sm ^intel-oneapi-mpi+external-libfabric
```

The command `spack install -j $(nproc) wrf%intel build_type=dm+sm ^intel-oneapi-mpi+external-libfabric` tells Spack to install [WRF](https://spack.readthedocs.io/en/latest/package_list.html#wrf) using the latest version in the [Spack recipe](https://github.com/spack/spack/blob/develop/var/spack/repos/builtin/packages/wrf/package.py). It passes some build flags:

| **Spack Flag**   | **Description** |
| ----------- | ----------- |
| `-j $(nproc)`     | Compile with all the cores on the HeadNode.   |
| `@4.3.3`    | Specify version [4.3.3](https://github.com/wrf-model/WRF/releases/tag/v4.3.3) of WRF. |
| `%intel`     | Specify the [Intel Compiler (icc)](https://spack.readthedocs.io/en/latest/package_list.html#intel-oneapi-compilers) we installed in [e. Install Intel Compilers](/02-cluster/06-install-intel-compilers.html#intel_compilers). |
| `build_type=dm+sm`       | Enable [hybrid parallelism](https://in.nau.edu/hpc/overview/using-the-cluster-advanced/parallelism/) MPI + OpenMP.     |
| `^intel-oneapi-mpi+external-libfabric`    | Uses Intel MPI which we added in [e. Install Intel MPI](/02-cluster/06-install-intel-compilers.html#intel_mpi).   |

This will take about **3 minutes** to install. While that's installing feel free to advance to the [next step](/03-wrf/02-conus-12km.html) and pull down the Conus 12-km model.
