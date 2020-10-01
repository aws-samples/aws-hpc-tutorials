#!/bin/bash
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
set +e

exec &> >(tee -a "/tmp/post_install.log")

. "/etc/parallelcluster/cfnconfig"

echo "post-install script has $# arguments"
for arg in "$@"
do
    echo "arg: ${arg}"
done

spack_install_path=${2:-/shared/spack}
spack_tag=${3:-releases/v0.15}

env > /opt/user_data_env.txt

case "${cfn_node_type}" in
    MasterServer)

        export AWS_DEFAULT_REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | rev | cut -c 2- | rev)
        aws configure set default.region ${AWS_DEFAULT_REGION}
        aws configure set default.output json

        # Setup spack on master:
        git clone https://github.com/spack/spack -b ${spack_tag} ${spack_install_path}

        # On both: load spack at login
        echo ". ${spack_install_path}/share/spack/setup-env.sh" > /etc/profile.d/spack.sh
        echo ". ${spack_install_path}/share/spack/setup-env.csh" > /etc/profile.d/spack.csh

        # Install Boto3
        yum install -y python3
        pip3 install boto3

        mkdir -p ${spack_install_path}/etc/spack
        mkdir -p ${spack_install_path}/var/spack/environments/aws
        # V2.0 borrowed "all:" block from https://spack-tutorial.readthedocs.io/en/latest/tutorial_configuration.html

        # Autodetect OPENMPI, INTELMPI, SLURM, LIBFABRIC and GCC versions to inform Spack of available packages.
        # e.g., OPENMPI_VERSION=4.0.3
        OPENMPI_VERSION=$(. /etc/profile && module avail openmpi 2>&1 | grep openmpi | head -n 1 | cut -d / -f 2)
        # e.g., INTELMPI_VERSION=2019.7.166
        INTELMPI_VERSION=$(. /etc/profile && module show intelmpi 2>&1 | grep I_MPI_ROOT | sed 's/[[:alpha:]|_|:|\/|(|[:space:]]//g' | awk -F- '{print $1}' )
        # e.g., SLURM_VERSION=19.05.5
        SLURM_VERSION=$(. /etc/profile && sinfo --version | cut -d' ' -f 2)
        # e.g., LIBFABRIC_VERSION=1.10.0
        # e.g., LIBFABRIC_MODULE=1.10.0amzn1.1
        LIBFABRIC_MODULE=$(. /etc/profile && module avail libfabric 2>&1 | grep libfabric | head -n 1 )
        LIBFABRIC_MODULE_VERSION=$(. /etc/profile && module avail libfabric 2>&1 | grep libfabric | head -n 1 |  cut -d / -f 2 )
        LIBFABRIC_VERSION=${LIBFABRIC_MODULE_VERSION//amzn*}
        # e.g., GCC_VERSION=7.3.5
        GCC_VERSION=$( gcc -v 2>&1 |tail -n 1| awk '{print $3}' )

        #NOTE: as of parallelcluster v2.8.0, SLURM is built with PMI3
        cat << EOF > ${spack_install_path}/var/spack/environments/aws/spack.yaml
spack:
  view: false
  concretization: separately

  config:
    install_tree: /shared/spack/opt/spack
    build_jobs: 4

  packages:
    all:
      providers:
        blas:
        - openblas
        mpi:
        - mpich
      variants: +mpi
    mpich:
      variants: ~wrapperrpath netmod=ofi
      version:
        - 3.2.1
    binutils:
      variants: +gold+headers+libiberty~nls
      version:
        - 2.33.1
    cmake:
      version:
        - 3.17.3
    openfoam:
      variants: +paraview
      version:
        - 'develop'
    paraview:
      variants: +osmesa+python3
      version:
        - 5.8.1
    mesa:
      variants: swr=avx,avx2
      version:
        - 18.3.6
    llvm:
      version:
        - 6.0.1
    hwloc:
      version:
        - 1.11.11

  definitions:
  - hackathon:
    - openfoam
    - gromacs
  - arch:
    - '%gcc@7.3.1 arch=linux-amzn2-skylake_avx512'
  mirrors: { "mirror": "s3://spack-mirrors/amzn2-e4s" }
EOF

    cat ${spack_install_path}/var/spack/environments/aws/spack.yaml

	  chown -R ${cfn_cluster_user}:${cfn_cluster_user} ${spack_install_path}
    chmod -R go+rwX ${spack_install_path}

    echo "spack env activate aws" >> ~/.bash_profile
    source /etc/profile.d/spack.sh
    su - ${cfn_cluster_user} -c "source /etc/profile"
    ;;
    ComputeFleet)
        # On both: load spack at login
        echo ". ${spack_install_path}/share/spack/setup-env.sh" > /etc/profile.d/spack.sh
        echo ". ${spack_install_path}/share/spack/setup-env.csh" > /etc/profile.d/spack.csh
    ;;
    *)
    ;;
esac
