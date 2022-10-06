+++
title = "a. Install EKS and Kubectl CLI"
date = 2022-09-28T10:46:30-04:00
weight = 10
tags = ["tutorial", "hpc", "Kubernetes"]
+++

#### Setting up your working environment

In this section, you will install `eksctl` and `kubectl`.

For the remainder of this lab, we will be working in the `environment` directory.

```bash
cd ~/environment
```

Several commands will specify the AWS region.  Export this as an environment variable that you can use through the following steps.

```bash
export AWS_REGION=us-east-2
```

#### Install eksctl

`eksctl` is a simple CLI tool for creating and managing Amazon EKS. It is written in Go, uses [AWS CloudFormation](https://aws.amazon.com/cloudformation/), was created by Weaveworks.

In your AWS Cloud9 terminal window paste the following commands to install `eksctl`:
```bash
curl --location "https://github.com/weaveworks/eksctl/releases/download/v0.112.0/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version
```

#### Install kubectl

`kubectl` is a command line utility for interacting with the Kubernetes API. It allows you to run commands against Kubernetes clusters, deploy applications, inspect and manage cluster resources, and view logs. For more information including a complete list of `kubectl` operations, see the [`kubectl` reference documentation](https://kubernetes.io/docs/reference/kubectl/).


In your AWS Cloud9 terminal window paste the following commands to install `kubectl`:
```bash
curl -Lo kubectl https://dl.k8s.io/release/v1.21.0/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin
kubectl version --client --short
```