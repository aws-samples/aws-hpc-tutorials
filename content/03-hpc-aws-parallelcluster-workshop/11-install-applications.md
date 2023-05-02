+++
title = "k. Install Spack & WRF"
date = 2023-04-10T10:46:30-04:00
weight = 110
tags = ["tutorial", "create", "ParallelCluster"]
+++

![WRF Logo](/images/hpc-aws-parallelcluster-workshop/WRF-Logo.jpg)

In this section of the lab we'll setup the [Weather Research and Forecasting Model (WRF)](https://ncar.ucar.edu/what-we-offer/models/weather-research-and-forecasting-model-wrf) and all its prerequisites. The WRF model is a mesoscale numerical weather prediction system designed for both atmospheric research and operational forecasting applications. It is developed and maintained by by [National Center for Atmospheric Research (NCAR)](https://ncar.ucar.edu/what-we-offer/models/weather-research-and-forecasting-model-wrf).

It's easy to install with the package manager Spack.

![Spack Logo](/images/hpc-aws-parallelcluster-workshop/spack.svg)

## Install Spack

[Spack](https://spack.io/) is a package manager for supercomputers, Linux, and macOS. It makes installing scientific software easy. Spack isn’t tied to a particular language; you can build a software stack in Python or R, link to libraries written in C, C++, or Fortran, and easily swap compilers or target specific microarchitectures. In this tutorial we'll use Spack to compile and install weather codes.

First, on the head node - which we [connected to via SSM or DCV](02-connect-cluster.html) we'll run:

```bash
export SPACK_ROOT=/shared/spack
git clone -b v0.19.1 -c feature.manyFiles=true https://github.com/spack/spack $SPACK_ROOT
echo "export SPACK_ROOT=/shared/spack" >> $HOME/.bashrc
echo "source \$SPACK_ROOT/share/spack/setup-env.sh" >> $HOME/.bashrc
source $HOME/.bashrc
```

## Spack Build Cache

We are going to install the weather codes from a Spack binary build cache/mirror. In order to do this we need to install a few more python packages.

```bash
pip3 install botocore boto3
```

Next we add the mirror and trust the GPG keys that have signed the packages.
If you want to verify the GPG keys, they are on [OpenGPG](https://keys.openpgp.org/search?q=aws-hpc-weather%40amazon.com).

```bash
spack mirror add aws-hpc-weather s3://aws-hpc-weather/spack_v0.19.1/
spack buildcache keys --install --trust --force
```

{{% notice warning %}}
The second line is broken.
==> Error: An error occurred (AccessDenied) when calling the GetObject operation: Access Denied

{{% /notice %}}

## Intel Compilers {#intel_compilers}

Next we'll use Spack to install the [Intel Compilers (ICC)](https://www.intel.com/content/www/us/en/developer/tools/oneapi/toolkits.html), we'll use these to compile binaries such as WRF in the next few sections:

```bash
spack install --no-cache intel-oneapi-compilers@2022.0.2
```

This will take about `~4 mins` to complete. Once it's complete we can see the installed package by running `spack find`:

```bash
spack find
```

![Intel compilers in Spack](/images/hpc-aws-parallelcluster-workshop/intel-oneapi-compilers.png)

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

![Spack Compilers](/images/hpc-aws-parallelcluster-workshop/spack-compilers.png)

## Libfabric {#libfabric}

We are going to install [libfabric](https://ofiwg.github.io/libfabric/) with [EFA](https://aws.amazon.com/hpc/efa/) support.

```bash
spack install libfabric@1.16.1 fabrics=efa,tcp,udp,sockets,verbs,shm,mrail,rxd,rxm %intel
```

## Intel MPI {#intel_mpi}

We will now install the [Intel MPI library](https://www.intel.com/content/www/us/en/developer/tools/oneapi/mpi-library.html) underneath the Intel compilers.
We are also going to use the AWS [EFA](https://aws.amazon.com/hpc/efa/) libfabric by setting `external-libfabric` in our Spack install. We installed this in the [previous step](#libfabric).

```bash
spack install --no-cache intel-oneapi-mpi+external-libfabric%intel
```

{{% notice note %}}
You can safely ignore the warning about patchelf:
`patchelf: cannot find section '.dynamic'. The input file is most likely statically linked`
{{% /notice %}}

This will take less than a minute to complete.

## NCL

1. Next we'll install the [NCAR Command Language (NCL)](https://www.ncl.ucar.edu/). We will use NCL to visualize the output in the next few sections.


```bash
spack install ncl^hdf5@1.8.22
```


| **Spack Flag** | **Description** |
| ----------- | ----------- |
| `ncl` | Install the NCL package. |
| `^hdf5@1.8.22` | Pin the HDF5 dependency at version 1.8.22. |

This will take about 4 minutes to complete.

2. To test and make sure `ncl` is setup correctly.

```bash
spack load ncl
ncl -h
```

You should see the following output:


```bash
Usage: ncl -fhnopxsPQV <args> <file.ncl>
         -f: use new file structure and NetCDF4 features when possible
         -h: print this message and exit
         -n: don't enumerate values in print()
         -o: retain former behavior for certain backwards-incompatible changes
         -p: don't page output from the system() command
         -x: echo NCL commands
         -s: disable pre-loading of default script files
         -P: enable NCL profiler
         -Q: turn off echo of NCL version and copyright info
         -V: print NCL version and exit
```

3. We will also set our default NCL X11 window size to be 1000x1000.

```bash
cat << EOF > $HOME/.hluresfile
*windowWorkstationClass*wkWidth  : 1000
*windowWorkstationClass*wkHeight : 1000
EOF
```

## WRF

Now that we've built a cluster, let's install WRF:

{{% notice note %}}
We're going to install WRF on the HeadNode, we're able to do this as the architecture of the HeadNode instance type, `c5n.xlarge`, matches the compute nodes so Spack does the correct [microarchitecture detection](https://spack.readthedocs.io/en/latest/basic_usage.html#support-for-specific-microarchitectures). In most other cases it makes sense to install on compute nodes.
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