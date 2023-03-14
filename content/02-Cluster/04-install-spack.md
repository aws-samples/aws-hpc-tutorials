---
title: "d. Install Spack"
weight: 24
tags: ["tutorial", "pcluster-manager", "ParallelCluster", "Spack"]
---

![Spack Logo](/images/pcluster/spack.svg)

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

