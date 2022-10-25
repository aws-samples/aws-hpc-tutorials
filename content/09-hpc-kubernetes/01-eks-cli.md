+++
title = "a. Install EKS and Kubectl CLI"
date = 2022-09-28T10:46:30-04:00
weight = 10
tags = ["tutorial", "hpc", "Kubernetes"]
+++

In this section, you will install `eksctl` and `kubectl`.

#### Install eksctl

`eksctl` is a simple CLI tool for creating and managing Amazon EKS. It is written in [Go](https://golang.google.cn/), uses [AWS CloudFormation](https://aws.amazon.com/cloudformation/), and was created by [Weaveworks](https://www.weave.works/). Learn more by visitng [https://eksctl.io](https://eksctl.io).

In your AWS Cloud9 terminal window paste the following commands to install `eksctl`:
```bash
cd ~/environment
curl --location "https://github.com/weaveworks/eksctl/releases/download/v0.112.0/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version
```

#### Install kubectl

`kubectl` is a command line utility for interacting with the Kubernetes API. It allows you to run commands against Kubernetes clusters, deploy applications, inspect and manage cluster resources, and view logs. For more information see the [reference documentation](https://kubernetes.io/docs/reference/kubectl/).


In your AWS Cloud9 terminal window paste the following commands to install `kubectl`:
```bash
curl -Lo kubectl https://dl.k8s.io/release/v1.21.0/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin
kubectl version --client --short
```

#### Install helm

`helm` is a package manager for Kubernetes. It allows easy deployment of software from a helm repository to your cluster. Learn more at [helm](https://helm.sh). 

To install helm, execute the following:

```bash
curl -L https://git.io/get_helm.sh | bash -s -- --version v3.8.2
```

You now have the tools needed to complete the HPC on Kubernetes lab.