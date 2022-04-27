+++
title = "a. Update your cluster"
date = 2019-09-18T10:46:30-04:00
weight = 30
tags = ["tutorial", "update", "ParallelCluster"]
+++

In this section, you will update the configuration of the HPC cluster you created in Lab I to:
- Create a post-install script to install Docker and Singularity.
- Provide access to the container registry, [Amazon Elastic Container Registry (ECR)](https://aws.amazon.com/ecr/).
- Create a new queue that will be used to run the containerized workload.
- Update the configuration of the HPC Cluster.

{{% notice warning %}}
The following commands must be executed on the AWS Cloud9 environment created at the beginning of the tutorial.
You can find the AWS Cloud9 environment by opening the [AWS Cloud9 console](https://console.aws.amazon.com/cloud9) and choose **Open IDE**
{{% /notice %}}

#### Preliminary

Starting with version 3.x, AWS ParallelCluster uses configuration file in `yaml` format.
For the following steps, you will use an utility to manipulate `yaml` files, named [yq](https://github.com/mikefarah/yq).
That will make the editing easier and more reproductible.

In the Cloud 9 Terminal, copy and paste the command below to install `yq`:

```bash
YQ_VERSION=4.21.1
sudo wget https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64 -O /usr/bin/yq && sudo chmod +x /usr/bin/yq
```

#### 1. Add a compute queue with a different instance type for running the container

In this step, you will add a new compute queue that use **c5.xlarge** EC2 instances.

Let create a new queue named __c5xlarge__:
```bash
yq -i '.Scheduling.SlurmQueues[1].Name = "c5xlarge"' ${PARALLELCLUSTER_CONFIG}
```

Let create a new compute resources named __c5xlarge__:
```bash
yq -i '.Scheduling.SlurmQueues[1].ComputeResources[0].Name = "c5xlarge"' ${PARALLELCLUSTER_CONFIG}
yq -i '.Scheduling.SlurmQueues[1].ComputeResources[0].InstanceType = "c5.xlarge"' ${PARALLELCLUSTER_CONFIG}
yq -i '.Scheduling.SlurmQueues[1].ComputeResources[0].MinCount = 0' ${PARALLELCLUSTER_CONFIG}
yq -i '.Scheduling.SlurmQueues[1].ComputeResources[0].MaxCount = 8' ${PARALLELCLUSTER_CONFIG}
yq -i '.Scheduling.SlurmQueues[1].Networking.SubnetIds[0] = strenv(SUBNET_ID)' ${PARALLELCLUSTER_CONFIG}
yq -i '.Scheduling.SlurmQueues[1].Image.CustomAmi = strenv(CUSTOM_AMI)' ${PARALLELCLUSTER_CONFIG}
```
#### 2. Access to the container registry

In this step, you will add permission to the HPC cluster configuration file to access the [Amazon Elastic Container Registry (ECR)](https://aws.amazon.com/ecr/) by adding the managed `AmazonEC2ContainerRegistryFullAccess` [AWS IAM](https://aws.amazon.com/iam/) policy.

```bash
yq -i '.HeadNode.Iam.AdditionalIamPolicies[1].Policy = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"' ${PARALLELCLUSTER_CONFIG}
yq -i '.Scheduling.SlurmQueues[1].Iam.AdditionalIamPolicies[0].Policy = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"' ${PARALLELCLUSTER_CONFIG}
```

#### 3. Create a post-install script

In this step, you will create a post-install script that installs Docker and Singularity on the compute nodes.

```bash
cat > ~/environment/post_install.sh << EOF
# Install Docker
sudo amazon-linux-extras install -y docker
sudo usermod -a -G docker ec2-user
sudo systemctl start docker
sudo systemctl enable docker

# Install Singularity
sudo yum install -y singularity
EOF
```

For your `post-install.sh` script to be use by the HPC Cluster, you will need to create [Amazon S3](https://aws.amazon.com/s3/) bucket and copy the `post-install.sh` script to the bucket.

```bash
BUCKET_POSTFIX=$(python3 -S -c "import uuid; print(str(uuid.uuid4().hex)[:10])")
export BUCKET_NAME_POSTINSTALL="parallelcluster-isc22-postinstall-${BUCKET_POSTFIX}"

aws s3 mb s3://${BUCKET_NAME_POSTINSTALL} --region ${AWS_REGION}
aws s3 cp ~/environment/post_install.sh s3://${BUCKET_NAME_POSTINSTALL}/
```

Now, you can add access to the `BUCKET_NAME_POSTINSTALL` bucket and specify the post install script path in the HPC cluster configuration file

```bash
PARALLELCLUSTER_CONFIG=~/environment/my-cluster-config.yaml
export BUCKET_NAME_POSTINSTALL_PATH="s3://${BUCKET_NAME_POSTINSTALL}/post_install.sh"
yq -i '.HeadNode.Iam.S3Access[0].BucketName = strenv(BUCKET_NAME_POSTINSTALL)' ${PARALLELCLUSTER_CONFIG}
yq -i '.Scheduling.SlurmQueues[1].Iam.S3Access[0].BucketName = strenv(BUCKET_NAME_POSTINSTALL)' ${PARALLELCLUSTER_CONFIG}
yq -i '.Scheduling.SlurmQueues[1].CustomActions.OnNodeConfigured.Script= strenv(BUCKET_NAME_POSTINSTALL_PATH)' ${PARALLELCLUSTER_CONFIG}
```

#### 4. Update your HPC Cluster

In this step, you will update your HPC cluster with the configuration changes made in the previous steps.

Prior to an update, the cluster should be a stopped state.

```bash
pcluster update-compute-fleet -n hpc-cluster-lab --status STOP_REQUESTED -r $AWS_REGION
```

Before proceeding to the cluster update, you can check the content of the configuration file that should look like this:

`cat ~/environment/my-cluster-config.ini`

```yaml
HeadNode:
  InstanceType: m5.2xlarge
  Ssh:
    KeyName: ${SSH_KEY_NAME}
  Networking:
    SubnetId: ${SUBNET_ID}
  LocalStorage:
    RootVolume:
      Size: 50
  Iam:
    AdditionalIamPolicies:
      - Policy: arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore
      - Policy: arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess
    S3Access:
      - BucketName: ${BUCKET_NAME_POSTINSTALL}
  Dcv:
    Enabled: true
  Imds:
    Secured: true
Scheduling:
  Scheduler: slurm
  SlurmQueues:
    - Name: queue0
      ComputeResources:
        - Name: queue0-c5n18xlarge
          MinCount: 0
          MaxCount: 2
          InstanceType: c5n.18xlarge
          DisableSimultaneousMultithreading: true
          Efa:
            Enabled: true
      Networking:
        SubnetIds:
          - ${SUBNET_ID}
        PlacementGroup:
          Enabled: true
      Image:
        CustomAmi: ${CUSTOM_AMI}
      ComputeSettings:
        LocalStorage:
          RootVolume:
            Size: 50
    - Name: c5xlarge
      ComputeResources:
        - Name: c5xlarge
          InstanceType: c5.xlarge
          MinCount: 0
          MaxCount: 8
      Networking:
        SubnetIds:
          - ${SUBNET_ID}
      Image:
        CustomAmi: ${CUSTOM_AMI}
      Iam:
        AdditionalIamPolicies:
          - Policy: arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess
        S3Access:
          - BucketName: ${BUCKET_NAME_POSTINSTALL}
      CustomActions:
        OnNodeConfigured:
          Script: s3://${BUCKET_NAME_POSTINSTALL}/post_install.sh
Region: eu-west-1
Image:
  Os: alinux2
  CustomAmi: ${CUSTOM_AMI}
SharedStorage:
  - Name: Ebs0
    StorageType: Ebs
    MountDir: /shared
    EbsSettings:
      VolumeType: gp2
      DeletionPolicy: Delete
      Size: '50'
```

Let update the cluster by running the **pcluster update** command

```bash
pcluster update-cluster -n hpc-cluster-lab -c ~/environment/my-cluster-config.yaml -r $AWS_REGION
```

Pay attention to the **old value** and **new value** fields. You will see a new instance type under new value field. The output will be similar to this:
<!---
![ParallelCluster Update](/images/container-pc/pcluster_update.png)
--->


Start your cluster again after update process is completed.

```bash
pcluster update-compute-fleet -n hpc-cluster-lab --status START_REQUESTED -r $AWS_REGION
```
