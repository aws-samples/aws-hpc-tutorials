+++
title = "f. Deploy MPI Operator"
date = 2022-09-28T10:46:30-04:00
weight = 60
tags = ["tutorial", "hpc", "Kubernetes"]
+++

In this section, you will deploy the Kubeflow MPI operator to your Kubernetes cluster.
MPI Operator provides a common Custom Resource Definition (CRD) for specifying single or parallel jobs. It takes care of creating the hostfile, generating ssh keys, waiting for worker pods to be ready and launching MPI jobs.
You can read more about how MPI Operator works on the [Kubeflow page](https://github.com/kubeflow/mpi-operator/blob/master/proposals/scalable-robust-operator.md#background). The operator currently supports Open MPI and Intel MPI trough the `mpiImplementation` variable that can be set to `OpenMPI` or `Intel`.
For this lab, you will use Open MPI to run GROMACS.

####  1. Deploy Kubeflow MPI oparator

To deploy the Kubeflow MPI operator to your Kubernetes cluster, execute the following command:

```bash
kubectl apply -f https://raw.githubusercontent.com/kubeflow/mpi-operator/v0.3.0/deploy/v2beta1/mpi-operator.yaml
```

####  2. Verify operator deployment

To verify that MPI operator is deployed successfully execute the following command:

```bash
kubectl get pods -n mpi-operator
```

You should see the MPI operator controller pod in Running state.

```text
mpi-operator   mpi-operator-65d47d6d67-zfb7z               1/1     Running   0          9s
```