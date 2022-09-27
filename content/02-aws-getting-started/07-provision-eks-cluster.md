+++
title = "e. Provision EKS Cluster"
weight = 80
tags = ["tutorial", "eks", "eksctl", "kubernetes"]
+++

There are several approaches that can be used to provision an EKS cluster. In this document we will show how to do that using the `eksctl` CLI. There are several tools and utilities that are helpful when working with Kubernetes, we've prepared a container project [`aws-do-eks`](https://github.com/aws-samples/aws-do-eks) which has these utilities installed, including `eksctl` and we will use that to provision a cluster for the lab. 

#### Clone the `aws-do-eks` project

First, clone the `aws-do-eks` project:

```
git clone https://github.com/aws-samples/aws-do-eks
```

#### Build the `aws-do-eks` container image

To build the `aws-do-eks` container image, execute the build script as shown below:

```
./build.sh
```

#### Run the `aws-do-eks` container

Run the `aws-do-eks` container by executing the run script:

```
./run.sh
```

#### Open a command shell into the running `aws-do-eks` container

We will complete the remaining steps from a shell within the running `aws-do-eks` container. To open a shell in the container, execute:

```
./exec.sh
```

#### Review cluster configuration

The cluster is described in a cluster manifest `eks-hpc.yaml`. To review the manifest, execute

```
vi /eks/eks-hpc.yaml
```

Press `ESC : q!` to return to the command shell

#### Configure project to use the `eks-hpc` manifest

```
vi /eks/eks.conf
```

Set:

```
export CONFIG=yaml
export EKS_YAML=./eks-hpc.yaml
export CLUSTER_NAME=eks-hpc
export CLUSTER_REGION=us-east-1
```

#### Create the `eks-hpc` cluster

To create the cluster, execute the `eks-create` script

```
./eks-create.sh
```

Note: cluster creation can take up to 30 min
