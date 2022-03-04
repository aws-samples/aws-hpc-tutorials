---
title: "f. Spack external packages"
weight: 25
tags: ["tutorial", "pcluster-manager", "ParallelCluster", "Spack"]
---

{{% notice note %}}
The versions of these external packages changes with the version of parallel
cluster. This `packages.yaml` is for parallel cluster version 3.1.1.
{{% /notice %}}

AWS ParallelCluster comes pre-installed with [Slurm](https://slurm.schedmd.com/), [libfabric](https://ofiwg.github.io/libfabric/), [PMIx](https://pmix.github.io/standard), [Intel MPI](https://www.intel.com/content/www/us/en/developer/tools/oneapi/mpi-library.html), and [Open MPI](https://www.open-mpi.org/). To use these packages, we need to tell [spack where to find them](https://spack.readthedocs.io/en/latest/build_settings.html#external-packages).

```bash
cat << EOF > $SPACK_ROOT/etc/spack/packages.yaml
packages:
    intel-mpi:
        externals:
        - spec: intel-mpi@2020.2.254
          prefix: /opt/intel/compilers_and_libraries_2020.2.254/linux/mpi/intel64
        buildable: False
    libfabric:
        variants: fabrics=efa,tcp,udp,sockets,verbs,shm,mrail,rxd,rxm
        externals:
        - spec: libfabric@1.13.2 fabrics=efa,tcp,udp,sockets,verbs,shm,mrail,rxd,rxm
          prefix: /opt/amazon/efa
        buildable: False
    openmpi:
        variants: fabrics=auto +pmix +legacylaunchers schedulers=slurm
        externals:
        - spec: openmpi@4.1.1 fabrics=auto +pmix +legacylaunchers schedulers=slurm
          prefix: /opt/amazon/openmpi
    pmix:
        externals:
          - spec: pmix@3.2.3 ~pmi_backwards_compatibility
            prefix: /opt/pmix
    slurm:
        variants: +pmix sysconfdir=/opt/slurm/etc
        externals:
        - spec: slurm@21.08.5 +pmix sysconfdir=/opt/slurm/etc
          prefix: /opt/slurm
        buildable: False
EOF
```

