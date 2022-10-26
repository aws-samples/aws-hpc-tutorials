---
title: "f. Spack external packages"
weight: 25
tags: ["tutorial", "pcluster-manager", "ParallelCluster", "Spack"]
---

AWS ParallelCluster comes pre-installed with [Slurm](https://slurm.schedmd.com/), [libfabric](https://ofiwg.github.io/libfabric/), [PMIx](https://pmix.github.io/standard), [Intel MPI](https://www.intel.com/content/www/us/en/developer/tools/oneapi/mpi-library.html), and [Open MPI](https://www.open-mpi.org/). We are going to use the pre-installed `libfabric`, to do so, we need to setup a [Spack external package](https://spack.readthedocs.io/en/latest/build_settings.html#external-packages) that points at the system `libfabric`.

```bash
cat << EOF > $SPACK_ROOT/etc/spack/packages.yaml
packages:
    libfabric:
        variants: fabrics=efa,tcp,udp,sockets,verbs,shm,mrail,rxd,rxm
        externals:
        - spec: libfabric@1.16.0 fabrics=efa,tcp,udp,sockets,verbs,shm,mrail,rxd,rxm
          prefix: /opt/amazon/efa
        buildable: False
EOF
```

