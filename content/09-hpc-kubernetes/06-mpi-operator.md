+++
title = "f. Deploy MPI Operator"
date = 2022-09-28T10:46:30-04:00
weight = 60
tags = ["tutorial", "hpc", "Kubernetes"]
+++

In this section, you will deploy the Kubeflow MPI operator to your Kubernetes cluster.
MPI Operator provides a common Custom Resource Definition (CRD) for defining single or parallel job. It takes care of creating the hostfile, generate ssh keys, wait the worker pods to be ready and launch the job.
You can read more about how the MPI Operator works in the [ Kubeflow page](https://github.com/kubeflow/mpi-operator/blob/master/proposals/scalable-robust-operator.md#background). The operator currently supports Open MPI and Intel MPI trough the `mpiImplementation` variable that can be set to `OpenMPI` or `Intel`.
You will use Open MPI with GROMACS for this lab.

####  1. Deploy Kubeflow MPI oparator

The Kubeflow MPI operator allows running tightly-coupled workloads on Kubernetes. It creates the MPIJob custom resource definition in your cluster. It also deploys a custom controller that handles MPIJobs.

```bash
kubectl apply -f https://raw.githubusercontent.com/kubeflow/mpi-operator/v0.3.0/deploy/v2beta1/mpi-operator.yaml
```

####  2. Check operator deployment

To check MPI operator is deployed successfully execute the following command

```bash
kubectl get pods -n mpi-operator
```

You should see the MPI operator controller pod in Running state.

```text
mpi-operator   mpi-operator-65d47d6d67-zfb7z               1/1     Running   0          9s
```