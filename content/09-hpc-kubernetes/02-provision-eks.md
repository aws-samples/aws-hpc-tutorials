+++
title = "b. Provision EKS cluster"
date = 2022-09-28T10:46:30-04:00
weight = 20
tags = ["tutorial", "hpc", "Kubernetes"]
+++

In this section, you will create a new Amazon EKS cluster. 

#### 1. Create the EKS manifest file

The EKS cluster manifest specifies the version of Kubernetes to deploy, the AWS region as well as the associated availability zones to use, the instance type and network settings. For this lab, you will mainly focus on those parameters but many more parameters can be setup in the EKS manifest. In this example, you will create a EKS cluster with a node composed of two c5n.18xlarge instances using [Elastic Fabric Adapter (EFA)](https://aws.amazon.com/hpc/efa/).

Let's create the manifest file by pasting the following commands into the Cloud9 terminal:

```bash
cat > ~/eks-hpc.yaml << EOF
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig

metadata:
  name: eks-hpc
  version: "1.21"
  region: us-east-2

availabilityZones:
  - us-east-2a
  - us-east-2b

iam:
  withOIDC: true

managedNodeGroups:
  - name: c5n-18xl
    instanceType: c5n.18xlarge
    instancePrefix: c5n-18xl
    privateNetworking: true
    availabilityZones: ["us-east-2a"]
    efaEnabled: true
    minSize: 0
    desiredCapacity: 2
    maxSize: 10
    volumeSize: 30
    iam:
      withAddonPolicies:
        autoScaler: true
        ebs: true
        fsx: true
EOF
```

Notice the `efaEnabled` flag in the manifest file. It will ask `eksctl` to create a node group with the correct setup for using [Elastic Fabric Adapter (EFA)](https://aws.amazon.com/hpc/efa/) network interface to run a tightly couple workload (MPI). `eksctl` will leverage AWS CloudFormation to create a [Placement group] (https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/placement-groups.html) that puts instance close together and a [EFA-enabled security group](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/efa-start.html#efa-start-security).

#### 2. Create the EKS cluster

It will take ~10 minutes to create the Kubernetes control plane and ~10 minutes to create the node group, in total ~20 minutes.

```
eksctl create cluster -f ~/eks-hpc.yaml
```

Upon successful completion, you will see a log line similar to this:

```
2022-09-29 03:34:37 [✔]  EKS cluster "eks-hpc" in "us-east-2" region is ready
```

#### 3. Check cluster creation using API.

To validate that the cluster was provisioned successfully and is ready for use, you will list the Kubernetes nodes by executing the following command:

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
aws eks update-kubeconfig --name eks-hpc --region ${AWS_REGION}
```

