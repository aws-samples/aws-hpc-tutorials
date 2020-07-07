+++
title = "a. Create a cluster configured with NICE DCV"
date = 2019-09-18T10:46:30-04:00
weight = 50
tags = ["tutorial", "initialize", "ParallelCluster", "DCV"]
+++

{{% notice info %}}Support for `dcv_settings` is supported in AWS ParallelCluster 2.5.0 or above.
{{% /notice %}}

In order to enable NICE DCV, a few changes to the config file need to be made. There's a complete config file included below with key changes:

1. To enable NICE DCV on the Master node

 - Add a line `dcv_settings = default` to the [cluster default] section of the config file.
 - Create a dcv section that references the value you chose for the dcv_settings and include the line `enable = master`
 - The NICE DCV software is automatically installed on the master instance when using `base_os = alinux2`, `base_os = centos7`, or `base_os = ubuntu1804`. We will use `base_os = centos7` for this tutorial.
 

2. Modify Master Nodes:

 - We will deploy the cluster with a GPU-enabled Master instance since the master node is hosting NICE DCV remote desktop sessions. 
 - Modify the `master_instance_type = g4dn.xlarge`. This will be a cost-effective option for graphics intensive applications 

{{% notice tip %}}
For more details about the NICE DCV configuration options in AWS ParallelCLuster, see the [NICE DCV section in AWS ParallelCluster User Guide](https://docs.aws.amazon.com/parallelcluster/latest/ug/dcv.html).
{{% /notice %}}

First we'll create a keypair:
```bash
# generate a new keypair, remove those lines if you want to use the previous one
aws ec2 create-key-pair --key-name lab-dcv-key --query KeyMaterial --output text > ~/.ssh/lab-dcv-key
chmod 600 ~/.ssh/lab-dcv-key
```

Then we'll create a config file, paste the following commands in your terminal. Note DCV-related items are highlighted:

{{< highlight go "linenos=false,hl_lines=19 31-34" >}}
IFACE=$(curl --silent http://169.254.169.254/latest/meta-data/network/interfaces/macs/)
SUBNET_ID=$(curl --silent http://169.254.169.254/latest/meta-data/network/interfaces/macs/${IFACE}/subnet-id)
VPC_ID=$(curl --silent http://169.254.169.254/latest/meta-data/network/interfaces/macs/${IFACE}/vpc-id)
AZ=$(curl http://169.254.169.254/latest/meta-data/placement/availability-zone)
REGION=${AZ::-1}

cd ~/environment
cat > my-dcv-cluster.ini << EOF
[aws]
aws_region_name = ${REGION}

[global]
cluster_template = default
update_check = false
sanity_check = true

[cluster default]
key_name = lab-dcv-key
base_os = centos7
vpc_settings = public
master_instance_type = g4dn.xlarge
compute_instance_type = c4.xlarge
cluster_type = ondemand
placement_group = DYNAMIC
placement = compute
initial_queue_size = 0
max_queue_size = 8
disable_hyperthreading = true
s3_read_write_resource = *
scheduler = slurm
dcv_settings = default

[dcv default]
enable = master

[vpc public]
vpc_id = ${VPC_ID}
master_subnet_id = ${SUBNET_ID}

[aliases]
ssh = ssh {CFN_USER}@{MASTER_IP} {ARGS}
EOF
{{< / highlight >}}

Now, you are ready to launch a cluster with Remote Desktop enabled using NICE DCV on your master node! Proceed to the next section.
