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
echo "EKS_CLUSTER_NAME=${EKS_CLUSTER_NAME}"

export AWS_REGION=${AWS_REGION:-us-east-1}
echo "AWS_REGION=${AWS_REGION}"

export AZ1_NAME=$(aws ec2 describe-availability-zones --region ${AWS_REGION} --query "AvailabilityZones[?ZoneId == 'use1-az1'].ZoneName" --output text )
echo "AZ1_NAME=${AZ1_NAME}"

export AZ2_NAME=$(aws ec2 describe-availability-zones --region ${AWS_REGION} --query "AvailabilityZones[?ZoneId == 'use1-az4'].ZoneName" --output text )
echo "AZ2_NAME=${AZ2_NAME}"

export IMAGE_URI=$(aws ecr --region ${AWS_REGION} describe-repositories --repository-name sc22-container --query "repositories[0].repositoryUri" --output text)
echo "IMAGE_URI=${IMAGE_URI}"
if [ "${IMAGE_URI}" == "" ]; then
  echo ""
  echo "The container image created in Lab 3 is required."
  echo "Please complete Lab 3, then try again."
  echo ""
fi
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
  - ${AZ1_NAME}
  - ${AZ2_NAME}

iam:
  withOIDC: true

managedNodeGroups:
  - name: hpc
    instanceType: c5.24xlarge
    instancePrefix: hpc
    privateNetworking: true
    availabilityZones: ["${AZ2_NAME}"]
    efaEnabled: false
    minSize: 0
    desiredCapacity: 1
    maxSize: 10
    volumeSize: 30
    iam:
      withAddonPolicies:
        autoScaler: true
        ebs: true
        fsx: true
EOF
```

Notice the `efaEnabled` flag in the manifest file. When set to `true`, `eksctl` will create a node group with the correct setup for using the [Elastic Fabric Adapter (EFA)](https://aws.amazon.com/hpc/efa/) network interface to run a tightly-coupled workload with MPI. `eksctl` will leverage AWS CloudFormation to create a [Placement group](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/placement-groups.html) that puts instances close together and a [EFA-enabled security group](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/efa-start.html#efa-start-security). If EFA is enabled, `instanceType` must be set to one of the [EC2 instance types with EFA support](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/efa.html#efa-instance-types), also the managedNodeGroup `availabilityZones` must be constrained to a single AZ. In this lab, we will not use EFA, so we are setting the value of this setting to `false`.

#### 2. Create the EKS cluster

It will take ~10 minutes to create the Kubernetes control plane and ~10 minutes to create the node group, in total ~20 minutes.

```
eksctl create cluster -f ~/environment/eks-hpc.yaml
```

Upon successful completion, you will see a log line similar to this:

```
2022-09-29 03:34:37 [✔]  EKS cluster "eks-hpc" in "us-east-1" region is ready
```




