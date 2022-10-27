---
title: "a. Install UFS"
weight: 51
tags: ["tutorial", "pcluster-manager", "ParallelCluster", "Spack"]
---

Now that we've built a cluster, let's install UFS:

{{% notice note %}}
We're going to install UFS on the HeadNode, we're able to do this as the architecture of the HeadNode instance type, `c6a.2xlarge`, matches the compute nodes so Spack does the correct [microarchitecture detection](https://spack.readthedocs.io/en/latest/basic_usage.html#support-for-specific-microarchitectures). In most other cases it makes sense to install on compute nodes.
{{% /notice %}}

```bash
spack install -j $(nproc) ufs-weather-model%intel^intel-oneapi-mpi+external-libfabric
EOF
```

The command `spack install -j $(nproc) ufs-weather-model%intel^intel-oneapi-mpi+external-libfabric` tells Spack to install [UFS](https://spack.readthedocs.io/en/latest/package_list.html#ufs-weather-model) using the latest version in the [Spack recipe](https://github.com/spack/spack/blob/develop/var/spack/repos/builtin/packages/ufs-weather-model/package.py). It passes some build flags:

| **Spack Flag**   | **Description** |
| ----------- | ----------- |
| `-j $(nproc)`     | Compile with all cores on the instance.   |
| `%intel`     | Specify the [Intel Compiler (icc)](https://spack.readthedocs.io/en/latest/package_list.html#intel-oneapi-compilers) we installed in [e. Install Intel Compilers](/02-cluster/06-install-intel-compilers.html#intel_compilers). |
| `^intel-oneapi-mpi+external-libfabric`  | Uses Intel MPI which we added in [e. Install Intel MPI](/02-cluster/06-install-intel-compilers.html#intel_mpi)

This will take about **1 minute** to install. While that's installing feel free to advance to the [next step](/05-ufs/02-simple-test.html) and pull down the simple test case.
