+++
title = "a. Provision EKS cluster"
date = 2022-09-28T10:46:30-04:00
weight = 80
tags = ["tutorial", "hpc", "Kubernetes"]
+++

In this section, you will create a new EKS cluster in your account. 


1. Install utilities

1.1. `eksctl` - command line utility for provisioning and management of EKS clusters

```bash
curl --location "https://github.com/weaveworks/eksctl/releases/download/v0.106.0/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version
```

1.2. `kubectl` - command line utility for interacting with the Kubernetes API

```bash
curl -Lo kubectl https://dl.k8s.io/release/v1.21.0/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin
kubectl version --client --short
```

2. Create a cluster manifest

Copy and paste the following content into a file named `eks-hpc.yaml`

```yaml
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig

metadata:
  name: eks-hpc
  version: "1.21"
  region: us-east-1

availabilityZones:
  - us-east-1a
  - us-east-1b

iam:
  withOIDC: true

managedNodeGroups:
  - name: c5n-18xl
    instanceType: c5n.18xlarge
    instancePrefix: c5n-18xl
    privateNetworking: true
    availabilityZones: ["us-east-1a"]
    efaEnabled: true
    minSize: 0
    desiredCapacity: 2
    maxSize: 10
    volumeSize: 900
    iam:
      withAddonPolicies:
        autoScaler: true
        ebs: true
```

3. Launch cluster provisioning

```
eksctl create cluster -f ./eks-hpc.yaml
```
Note: It takes about 20 minutes to provision a new cluster.

Upon successful completion, you will see a log line similar to this:

```
2022-09-29 03:34:37 [✔]  EKS cluster "eks-hpc" in "us-east-1" region is ready
```

4. Access cluster API

To validate that the cluster was provisioned successfully and is ready for use, execute the following command:

```bash
kubectl get nodes -o wide
```

You should see a list of two nodes similar to the one shown below.

```
NAME                             STATUS   ROLES    AGE     VERSION
ip-192-168-86-187.ec2.internal   Ready    <none>   4m54s   v1.21.14-eks-ba74326
ip-192-168-86-17.ec2.internal   Ready    <none>   4m54s   v1.21.14-eks-ba74326
```

**Troubleshooting**

If your kubectl client is unable to connect to the cluster, you may try to update the connection information by executing the command below, then try accessing the cluster API again.

```bash
aws eks update-kubeconfig --name eks-hpc --region us-east-1
```

