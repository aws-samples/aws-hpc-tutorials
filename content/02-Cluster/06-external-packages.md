---
title: "f. Spack external packages"
weight: 26
tags: ["tutorial", "pcluster-manager", "ParallelCluster", "Spack"]
---

AWS ParallelCluster comes pre-installed with Slurm, libfabric, Intel MPI and Open MPI. To use these packages, we need to tell [spack where to find them](https://spack.readthedocs.io/en/latest/build_settings.html#external-packages). We are not going to use the included Intel MPI as we have installed it ourselves [**e. Spack Install Intel Compilers**](/02-Cluster/05-install-intel-compilers.md)

```bash
cat <<- EOF > $SPACK_ROOT/etc/spack/packages.yaml
packages:
    slurm:
        externals:
        - spec: slurm@20.11.7
          prefix: /opt/slurm
        buildable: False
    libfabric:
        externals:
        - spec: libfabric@1.13.2
          prefix: /opt/amazon/efa
        buildable: False
    openmpi:
        externals:
        - spec: openmpi@4.1.1
          prefix: /opt/amazon/openmpi
        buildable: False
EOF
```

Alternatively we can have Spack find these [packages automatically](https://spack.readthedocs.io/en/latest/build_settings.html#automatically-find-external-packages) by running:

```bash
module load openmpi libfabric-aws
spack external find
```

Run `spack find` to see all the packages that are loaded in (external and internal):

![Spack Find](/images/pcluster/spack-find.png)
