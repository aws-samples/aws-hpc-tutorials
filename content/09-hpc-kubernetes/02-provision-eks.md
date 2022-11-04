+++
title = "b. Create EKS cluster"
date = 2022-09-28T10:46:30-04:00
weight = 20
tags = ["tutorial", "hpc", "Kubernetes"]
+++

In this section, you will create a new Amazon EKS cluster. 
Prior to the start, we can ensure our environment variables are set by executing:

```bash
echo export EKS_CLUSTER_NAME=eks-hpc >> env_vars

source env_vars

echo ${AWS_REGION}
echo ${SUBNET_ID}
echo ${EKS_CLUSTER_NAME}
```


#### 1. Create the EKS manifest file

The EKS cluster manifest specifies the version of Kubernetes to deploy, the AWS region as well as the associated availability zones to use, the instance type and network settings. For this lab, you will mainly focus on those parameters but many more parameters can be setup in the EKS manifest. In this example, you will create a EKS cluster with a node group composed of two hpc6a.48xlarge instances using [Elastic Fabric Adapter (EFA)](https://aws.amazon.com/hpc/efa/).

Let's create the manifest file by pasting the following commands into the Cloud9 terminal:

```bash
cat > ~/environment/eks-hpc.yaml << EOF
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig

metadata:
  name: ${EKS_CLUSTER_NAME}
  version: "1.21"
  region: ${AWS_REGION}

availabilityZones:
  - ${AWS_REGION}a
  - ${AWS_REGION}b

iam:
  withOIDC: true

managedNodeGroups:
  - name: hpc
    instanceType: hpc6a.48xlarge
    instancePrefix: hpc
    privateNetworking: true
    availabilityZones: ["${AWS_REGION}b"]
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

Notice the `efaEnabled` flag in the manifest file. It will ask `eksctl` to create a node group with the correct setup for using the [Elastic Fabric Adapter (EFA)](https://aws.amazon.com/hpc/efa/) network interface to run a tightly-coupled workload with MPI. `eksctl` will leverage AWS CloudFormation to create a [Placement group](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/placement-groups.html) that puts instances close together and a [EFA-enabled security group](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/efa-start.html#efa-start-security).

#### 2. Create the EKS cluster

It will take ~10 minutes to create the Kubernetes control plane and ~10 minutes to create the node group, in total ~20 minutes.

```
eksctl create cluster -f ~/environment/eks-hpc.yaml
```

Upon successful completion, you will see a log line similar to this:

```
2022-09-29 03:34:37 [✔]  EKS cluster "eks-hpc" in "us-east-2" region is ready
```




