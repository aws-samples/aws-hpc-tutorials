+++
title = "a. Create a cluster configured with NICE DCV"
date = 2019-09-18T10:46:30-04:00
weight = 50
tags = ["tutorial", "initialize", "ParallelCluster", "DCV"]
+++

{{% notice info %}}Support for DCV is supported in AWS ParallelCluster version 2.5.0 and above.
{{% /notice %}}

In order to enable NICE DCV, a few changes to the config file need to be made. There's a complete config file included below with key changes:

1. To enable NICE DCV on the Master node

 - Add the following to the configuration file:
```yaml
HeadNode:
  Dcv:
    Enabled: true
```

 - The NICE DCV software is automatically installed on the head node instance when using any of the following Operating Systems: `alinux2`, `centos7`, or `ubuntu1804`. We will use `centos7` for this tutorial.
 

2. Modify Master Nodes:

 - We will deploy the cluster with a GPU-enabled head node instance since it is hosting NICE DCV remote desktop sessions. 
 - Under `HeadNode:` section, set `InstanceType: g4dn.xlarge`. This will be a cost-effective option for graphics intensive applications. 

{{% notice tip %}}
For more details about the NICE DCV configuration options in AWS ParallelCLuster, see the [NICE DCV section in AWS ParallelCluster User Guide](https://docs.aws.amazon.com/parallelcluster/latest/ug/dcv-v3.html).
{{% /notice %}}

We'll reuse the [**SSH key-pair**](/02-aws-getting-started/05-key-pair-create.html) created earlier.
```bash
echo "export AWS_KEYPAIR=lab-your-key" >> ~/.bashrc
source ~/.bashrc
```

Then we'll create a config file (dcv-config.yaml). Paste the following commands in your terminal.

```bash
IFACE=$(curl --silent http://169.254.169.254/latest/meta-data/network/interfaces/macs/)
SUBNET_ID=$(curl --silent http://169.254.169.254/latest/meta-data/network/interfaces/macs/${IFACE}/subnet-id)
VPC_ID=$(curl --silent http://169.254.169.254/latest/meta-data/network/interfaces/macs/${IFACE}/vpc-id)
AZ=$(curl http://169.254.169.254/latest/meta-data/placement/availability-zone)
REGION=${AZ::-1}
```

```yaml
cat > dcv-config.yaml << EOF
Region: ${REGION}
Image:
  Os: centos7
SharedStorage:
  - MountDir: /shared
    Name: default-ebs
    StorageType: Ebs

HeadNode:
  InstanceType: g4dn.xlarge
  Networking:
    SubnetId: ${SUBNET_ID}
  Ssh:
    KeyName: {AWS_KEYPAIR}
  Dcv:
    Emabled: true

Scheduling:
  Scheduler: slurm
  SlurmQueues:
    - Name: compute
      ComputeResources:
        - Name: c5xlarge
          InstanceType: c5.xlarge
          MinCount: 0
          MaxCount: 8
          DisableSimultaneousMultithreading: true
      Networking:
        SubnetIds:
          - ${SUBNET_ID}
        PlacementGroup:
          Enabled: true
EOF
```
Now, you are ready to launch a cluster with Remote Desktop enabled using NICE DCV on your head node! Proceed to the next section.
