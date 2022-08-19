---
title: "f. Create Ray Cluster"
date: 2022-08-19
weight: 80
tags: ["Ray", "Cluster"]
---

To create ray cluster, we need a .yaml file with the necessary configuration. Copy the following configuration to **cluster.yaml**:

```yaml
cluster_name: workshop

# The node config specifies the launch config and physical instance type.
available_node_types:
    ray.head:
        node_config:
            SubnetIds: [SUBNET] # ray-subnet-public1
            ImageId: AMI_ID
            IamInstanceProfile:
                Arn: RAY_HEAD_IAM_ROLE_ARN
            InstanceType: g4dn.xlarge

    ray.worker.gpu:
        # The minimum number of nodes of this type to launch.
        min_workers: 2
        # The maximum number of workers nodes of this type to launch.
        max_workers: 2
        resources: {"node_type_gpu": 1}
        node_config:
            SubnetIds: [SUBNET] # ray-subnet-public1
            ImageId: AMI_ID
            IamInstanceProfile:
                Arn: RAY_WORKER_IAM_ROLE_ARN
            InstanceType: g4dn.2xlarge

head_node_type: ray.head
# Cloud-provider specific configuration.
provider:
    type: aws
    region: us-west-2
    # Availability zone(s), comma-separated, that nodes may be launched in.
    availability_zone: us-west-2a
    cache_stopped_nodes: False # If not present, the default is True.
    security_group:
        GroupName: ray-cluster-sg
    cloudwatch:
        agent:
            config: "cloudwatch-agent-config.json"

# How Ray will authenticate with newly launched nodes.
auth:
    ssh_user: ubuntu

# List of shell commands to run to set up nodes.
setup_commands:
    - FSXL_MOUNT_COMMAND

# Command to start ray on the head node. You don't need to change this.
head_start_ray_commands:
    - ray stop
    - ulimit -n 65536; ray start --head --port=6379 --autoscaling-config=~/ray_bootstrap_config.yaml
# Command to start ray on worker nodes. You don't need to change this.
worker_start_ray_commands:
    - ray stop
    - ulimit -n 65536; ray start --address=$RAY_HEAD_IP:6379
```

|PlaceHolder |Replace With |
|------------ |-------------- |
|SUBNET      |subnet-xxxxxxxxxxxxxxxxx |
|RAY_HEAD_IAM_ROLE_ARN |arn:aws:iam::xxxxxxxxxxxx:instance-profile/ray-head |
|RAY_WORKER_IAM_ROLE_ARN |arn:aws:iam::xxxxxxxxxxxx:instance-profile/ray-worker |
|FSXL_MOUNT_COMMAND | sudo mount command from FSxL console (see below) |

To get the mount command for FSxL, navigate to the **ray-fsx** file system we created in section **c** and click Attach. This will show an information pan. Copy the command from step 3. under Attach instructions. It looks something like this:
```bash
sudo mount -t lustre -o noatime,flock fs-xxxxxxxxxxxxxxxxx.fsx.us-west-2.amazonaws.com@tcp:/xxxxxxxx /fsx
```

Before we can launch the cluster, we also have to install ray in Cloud9:
```bash
pip install boto3 ray[default]
```

Now we're ready to spin up the cluster:
```bash
ray up -y cluster.yaml
```
The command will exit once the head node is set up. The worker nodes are launched after that. The whole process takes 5-10 min to launch all the nodes.

To the check the status of the cluster, we can log in to the head node using the following command:
```bash
ray attach cluster.yaml
```

And, from inside the head node, execute:
```bash
ray status
```

You would see an output like this:
```bash
======== Autoscaler status: 2022-08-19 23:49:05.950418 ========
Node status
---------------------------------------------------------------
Healthy:
 1 ray.head
 2 ray.worker.gpu
Pending:
 (no pending nodes)
Recent failures:
 (no failures)

Resources
---------------------------------------------------------------
Usage:
 0.0/20.0 CPU
 0.0/3.0 GPU
 0.0/3.0 accelerator_type:T4
 0.00/53.603 GiB memory
 0.0/2.0 node_type_gpu
 0.00/22.577 GiB object_store_memory

Demands:
 (no resource demands)
```
