---
title: "e. (optional) WRF Manual Install"
weight: 35
tags: ["tutorial", "pcluster-manager", "ParallelCluster", "Spack"]
---
In [**a. Spack Install WRF**](/03-wrf/01-spack-install-wrf.html) we installed WRF using a package manager, Spack. In this section we're going to compile it by hand, still building dependencies with WRF. You might need to do this if you:

1. Need to use a [version](https://www.mmm.ucar.edu/wrf-release-information) not currently supported by Spack
2. Want to use a modified version of WRF. 

In most other cases, the Spack approach will be better.
We're going to create a [Spack environment](https://spack.readthedocs.io/en/latest/environments.html) for our dependencies, think of this similar to a python virtual environment, it defines the packages and specific variants we need and installs them into their own environment, which can be loaded via `spack env activate` command.
All of these steps will be done on a compute node, so our build matches the architecture that we will be running on.

1. Get an interactive session on a compute node, this may take 2 to 3 minutes if all the nodes are powered down.
```bash
srun -N 1 --exclusive --pty /bin/bash -il
```
2. Create the following spack environment file, specifying all the
   dependencies of WRF:
```bash
cat <<- EOF > wrf_build.yaml
# This is a Spack Environment file.
#
# It describes a set of packages to be installed, along with
# configuration settings.
spack:
  concretization: together
  packages:
    all:
      compiler: [intel]
      providers:
        mpi: [intel-oneapi-mpi+external-libfabric%intel]
  specs:
  - intel-oneapi-compilers
  - intel-oneapi-mpi+external-libfabric%intel
  - jasper%intel
  - netcdf-c%intel
  - netcdf-fortran%intel
  - parallel-netcdf%intel
  view: true
EOF
```
3. Next create the environment and install the packages, this will take **~ 25 mins**.
```bash
spack env create wrf_build wrf_build.yaml
spack env activate wrf_build
spack install --reuse -j 16
```
4. Finally we're going to compile WRF using the dependencies we just installed:
```bash
# load the Intel compilers and MPI package
spack load intel-oneapi-compilers
spack load intel-oneapi-mpi
# set dependency paths from spack environment
export HDF5=$SPACK_ENV/.spack-env/view/
export JASPERINC=$SPACK_ENV/.spack-env/view/include
export JASPERLIB=$SPACK_ENV/.spack-env/view/lib
export NETCDF=$SPACK_ENV/.spack-env/view/
export PNETCDF=$SPACK_ENV/.spack-env/view/
# download source from Github
wget https://github.com/wrf-model/WRF/archive/refs/tags/v4.3.3.tar.gz
tar -xzf v4.3.3.tar.gz
# configure
cd WRF-4.3.3
./configure
```
When prompted select **Enter selection [1-75] : 67**:
```bash
Enter selection [1-75] : 67
------------------------------------------------------------------------
Compile for nesting? (1=basic, 2=preset moves, 3=vortex following) [default 1]: 1
```
Now compile:
```bash
./compile -j 4 em_real 2>&1 | tee compile.log
```
5. Once WRF has been built, we no longer need the compute node.
```bash
exit
```
