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

Prior to version 3.x, AWS ParallelCluster uses configuration file in `ini` format.
For the following steps, you will use an utility to manipulate `ini` files, named [crudini](https://github.com/pixelb/crudini).
That will make the editing easier and more reproductible.

In the Cloud 9 Terminal, copy and paste the command below to install `crudini`:

```bash
pip3 install crudini -U --user
```

#### 1. Create a post-install script

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
BUCKET_NAME_POSTINSTALL="parallelcluster-sc21-postinstall-${BUCKET_POSTFIX}"

aws s3 mb s3://${BUCKET_NAME_POSTINSTALL} --region ${AWS_REGION}
aws s3 cp ~/environment/post_install.sh s3://${BUCKET_NAME_POSTINSTALL}/
```

Now, you can add access to the `BUCKET_NAME_POSTINSTALL` bucket and specify the post install script path in the HPC cluster configuration file

```bash
PARALLELCLUSTER_CONFIG=~/environment/my-cluster-config.ini
crudini --set ${PARALLELCLUSTER_CONFIG} "cluster default" s3_read_resource "arn:aws:s3:::${BUCKET_NAME_POSTINSTALL}*"
crudini --set ${PARALLELCLUSTER_CONFIG} "cluster default" post_install "s3://${BUCKET_NAME_POSTINSTALL}/post_install.sh"
```

#### 2. Access to the container registry

In this step, you will add permission to the HPC cluster configuration file to access the [Amazon Elastic Container Registry (ECR)](https://aws.amazon.com/ecr/) by adding the managed `AmazonEC2ContainerRegistryFullAccess` [AWS IAM](https://aws.amazon.com/iam/) policy.

```bash
crudini --set --list ${PARALLELCLUSTER_CONFIG} "cluster default" additional_iam_policies "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
```

#### 3. Add a compute queue

In this step, you will a new compute queue that use **c5.xlarge** EC2 instances.

Let create a new compute resources named __c5xlarge__:
```bash
crudini --set ${PARALLELCLUSTER_CONFIG} "compute_resource c5xlarge" instance_type "c5.xlarge"
crudini --set ${PARALLELCLUSTER_CONFIG} "compute_resource c5xlarge" min_count "0"
crudini --set ${PARALLELCLUSTER_CONFIG} "compute_resource c5xlarge" max_count "8"
```

Let create a new queue named __c5xlarge__:
```bash
crudini --set ${PARALLELCLUSTER_CONFIG} "queue c5xlarge" compute_resource_settings "c5xlarge"
```

Let add the new  __c5xlarge__ queue to the cluster:
```bash
crudini --set ${PARALLELCLUSTER_CONFIG} "cluster default" queue_settings "c5xlarge, c5n18large"
```

#### 4. Update your HPC Cluster

In this step, you will update your HPC cluster with the configuration changes made in the previous steps.

Prior to an update, the cluster should be a stopped state.

```bash
pcluster stop hpclab-yourname -r $AWS_REGION
```

Before proceeding to the cluster update, you can check the content of the configuration file that should look like this:

`cat ~/environment/my-cluster-config.ini`

```bash
[vpc public]
vpc_id = ${VPC_ID}
master_subnet_id = ${SUBNET_ID}

[global]
cluster_template = default
update_check = true
sanity_check = true

[cluster default]
key_name = ${SSH_KEY_NAME}
base_os = ${BASE_OS}
scheduler = ${SCHEDULER}
fsx_settings = myfsx
master_instance_type = c5.xlarge
master_root_volume_size = 40
compute_root_volume_size = 40
additional_iam_policies = arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore, arn:aws:iam::aws:policy/service-role/AmazonSSMMaintenanceWindowRole, arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess
vpc_settings = public
ebs_settings = myebs
queue_settings = c5xlarge, c5n18large
custom_ami = ${CUSTOM_AMI}
s3_read_resource = arn:aws:s3:::${BUCKET_NAME_POSTINSTALL}*
post_install = s3://${BUCKET_NAME_POSTINSTALL}/post_install.sh

[queue c5n18large]
compute_resource_settings = c5n18large
disable_hyperthreading = true
enable_efa = true
placement_group = DYNAMIC

[compute_resource c5n18large]
instance_type = c5n.18xlarge
min_count = 0
max_count = 2

[fsx myfsx]
shared_dir = /fsx
storage_capacity = 1200
deployment_type = SCRATCH_2

[ebs myebs]
shared_dir = /shared
volume_type = gp2
volume_size = 20

[aliases]
ssh = ssh {CFN_USER}@{MASTER_IP} {ARGS}

[compute_resource c5xlarge]
instance_type = c5.xlarge
min_count = 0
max_count = 8

[queue c5xlarge]
compute_resource_settings = c5xlarge
```

Let update the cluster by running the **pcluster update** command

```bash
pcluster update hpclab-yourname -c my-cluster-config.ini -r $AWS_REGION
```

Pay attention to the **old value** and **new value** fields. You will see a new instance type under new value field. The output will be similar to this:
![ParallelCluster Update](/images/container-pc/pcluster_update.png)


Start your cluster again after update process is completed.

```bash
pcluster start hpclab-yourname -r $AWS_REGION
```
