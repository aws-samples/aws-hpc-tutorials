---
title: "d. Install Spack"
weight: 24
tags: ["tutorial", "pcluster-manager", "ParallelCluster", "Spack"]
---

![Spack Logo](/images/pcluster/spack.svg)

[Spack](https://spack.io/) is a package manager for supercomputers, Linux, and macOS. It makes installing scientific software easy. Spack isn’t tied to a particular language; you can build a software stack in Python or R, link to libraries written in C, C++, or Fortran, and easily swap compilers or target specific microarchitectures. In this tutorial we'll use Spack to compile and install weather codes.

First, on the head node - which we [connected to via SSM or DCV](02-connect-cluster.html) we'll run:

```bash
sudo su
export SPACK_ROOT=/shared/spack
mkdir -p $SPACK_ROOT
git clone -c feature.manyFiles=true https://github.com/spack/spack $SPACK_ROOT
cd $SPACK_ROOT
exit
echo "export SPACK_ROOT=/shared/spack" >> $HOME/.bashrc
echo "source \$SPACK_ROOT/share/spack/setup-env.sh" >> $HOME/.bashrc
source $HOME/.bashrc
sudo chown -R $USER:$USER $SPACK_ROOT
```

Let's go ahead and verify spack is installed correctly by installing `patchelf`:

```bash
spack install patchelf
```

Once this completes we can see the installed package by running `module avail`:

```bash
module avail
```

To use it, load it in with `module load` (look at the output of *module avail* to get exact name):

```bash
module load patchelf-0.13-gcc-7.3.1-bm67ztq
patchelf --version
```