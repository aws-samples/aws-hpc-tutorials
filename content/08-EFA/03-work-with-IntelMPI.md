---
title: "d. Work With Intel MPI"
date: 2020-05-12T12:57:20Z
weight : 30
tags : ["tutorial", "EFA", "ec2", "IntelMPI", "MPI", "intel", "module"]
---


In this section, Learn how to work with [Intel MPI](https://www.intel.com/content/www/us/en/developer/tools/oneapi/mpi-library.html) on AWS ParallelCluster.

#### Enable Intel MPI

Intel MPI is available on the AWS ParallelCluster AMIs for alinux, alinux2, centos7, ubuntu1604, and ubuntu1804 values for the [**Image: Os:**](https://docs.aws.amazon.com/parallelcluster/latest/ug/cluster-definition.html#base-os) setting.

{{% notice info %}}
Using Intel MPI indicates that you accept the Intel Simplified Software License.
{{% /notice %}}

[Open MPI](https://www.open-mpi.org/) is placed on the path by default. To enable Intel MPI instead of Open MPI, the Intel MPI module must be loaded first. The exact name of the module changes with every update.
To see which modules are available, run **module avail**,
```bash
module avail
```

the output of the command is something like this:
```bash
------------------------- /usr/share/Modules/modulefiles-------------------------
dot                        module-git                 modules                    openmpi/4.0.3
libfabric-aws/1.9.0amzn1.1 module-info                null                       use.own

---------------- /opt/intel/impi/2019.7.217/intel64/modulefiles/ ----------------
intelmpi
```

To load a module, run **module load modulename**. You can add this to the script that needs to use Intel MPI.

```bash
module load intelmpi
```

To see which modules are currently loaded, run **module list**.

```bash
module list
```
You'll see **intelmpi** is loaded:

```bash
Currently Loaded Modulefiles:
  1) /intelmpi
```

#### Understand Intel MPI version

To verify that Intel MPI is enabled and what version is installed, run **mpirun --version**.

```bash
mpirun --version
```
the output of the command is something like this:

```bash
Intel(R) MPI Library for Linux* OS, Version 2019 Update 8 Build 20200624 (id: 4f16ad915)
Copyright 2003-2020, Intel Corporation.
```
