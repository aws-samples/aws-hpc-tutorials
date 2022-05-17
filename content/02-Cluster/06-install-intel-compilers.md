---
title: "e. Install Intel Compilers & MPI"
weight: 26
tags: ["tutorial", "pcluster-manager", "ParallelCluster", "Spack"]
---

## Intel Compilers {#intel_compilers}

Next we'll use Spack to install the [Intel Compilers (ICC)](https://www.intel.com/content/www/us/en/developer/tools/oneapi/toolkits.html), we'll use these to compile binaries such as WRF in the next few sections:

```bash
spack install --no-cache intel-oneapi-compilers@2022.0.2
```

This will take about `~4 mins` to complete. Once it's complete we can see the installed package by running `spack find`:

```bash
spack find
```

![Intel compilers in Spack](/images/pcluster/intel-oneapi-compilers.png)

To use a package, we load it in with `spack load`. In order for Spack to be
able to use the compiler to build further packages, we need to inform Spack
about them, this is done with `spack compiler find`. Finally, when we do not
need a package we unload it.

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
We are also going to use the AWS [EFA](https://aws.amazon.com/hpc/efa/) libfabric by setting `external-libfabric` in our Spack install. We told Spack this was already installed in the [previous step](05-external-packages.html). The AWS libfabric library is optimized for EFA and we recommend using it over the libfabric bundled with Intel MPI.

```bash
spack install --no-cache intel-oneapi-mpi+external-libfabric%intel
```

{{% notice note %}}
You can safely ignore the warning about patchelf:
`patchelf: cannot find section '.dynamic'. The input file is most likely statically linked`
{{% /notice %}}

This will take less than a minute to complete.
