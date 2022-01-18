---
title: "c. Custom Build WRF"
weight: 35
tags: ["tutorial", "pcluster-manager", "ParallelCluster", "Spack"]
---

To build a custom version of WRF, we first create a Spack environment configuration file that
contains all the dependencies of WRF.

```bash
mkdir /shared/wrf_build && cd $_
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
        mpi: [intel-mpi%intel]
  specs:
  - intel-oneapi-compilers
  - intel-oneapi-mpi%intel
  - jasper%intel
  - netcdf-c%intel
  - netcdf-fortran%intel
  - parallel-netcdf%intel
  view: true
EOF
```

Next, we create a job script and submit that to the cluster to will install the dependencies.

```bash
cat <<- EOF > install_deps.sh
#!/bin/bash

#SBATCH --job-name=Install_Deps
#SBATCH --output=install-%j.out
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=96
#SBATCH --exclusive

spack env create wrf_build wrf_build.yaml
spack env activate -p wrf_build
spack install
spack env deactivate
```

Submit the job:

```bash
sbatch install_deps.sh
```

Once all the dependencies are install we can build WRF. Note, we are going to do this
interactively on a compute node.

```bash
srun -N 1 --pty /bin/bash -il

spack env activate -p wrf_build

wget https://github.com/wrf-model/WRF/archive/refs/tags/v4.3.3.tar.gz

export HDF5=$SPACK_ENV/.spack-env/view/
export JASPERINC=$SPACK_ENV/.spack-env/view/include
export JASPERLIB=$SPACK_ENV/.spack-env/view/lib
export NETCDF=$SPACK_ENV/.spack-env/view/
export PNETCDF=$SPACK_ENV/.spack-env/view/

tar xf v4.3.3.tar.gz
cd WRF-4.3.3
./configure
./compile em_real 2>&1 | tee compile.log
exit
```

