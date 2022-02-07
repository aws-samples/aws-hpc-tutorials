---
title: "b. Supercell Test Case"
weight: 42
tags: ["tutorial", "pcluster-manager", "ParallelCluster", "Spack"]
---

In this section, you will go through the steps to run a supercell test case on AWS ParallelCluster.

## Download supercell test case

The supercell thunderstorm is an idealized test-case on the Cartesian plane. The test-case includes an MPAS mesh file, mesh decomposition files for certain MPI tasks counts, a namelist file for creating initial conditions and a namelist file for running the model.


```bash
cd /shared
curl -LO http://www2.mmm.ucar.edu/projects/mpas/test_cases/v7.0/supercell.tar.gz
tar xf supercell.tar.gz
```

## Create a decomposition graph

We need to create a decomposition graph for the number of MPI ranks that we
will run MPAS on.

1. Install [METIS](http://glaros.dtc.umn.edu/gkhome/metis/metis/overview) a graph partitioning program. This will take **~5 minutes**.

```bash
spack install metis%intel
```

2. Create a graph for the number of MPI ranks we will run MPAS on.

```bash
cd supercell
spack load metis%intel
gpmetis -minconn -contig -niter=200 supercell.graph.info 32
```


