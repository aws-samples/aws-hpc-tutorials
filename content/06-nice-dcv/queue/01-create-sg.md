+++
title = "a. Create Security Group"
date = 2019-09-18T10:46:30-04:00
weight = 10
tags = ["tutorial", "NICE DCV", "ParallelCluster", "Remote Desktop"]
+++

{{% notice info %}}
If you'd like to keep the Security Group locked down, skip this step and follow the instructions in [b. Modify Cluster Config](/06-nice-dcv/queue/02-edit-cluster.html) and [d. No-Ingress DCV Session](/06-nice-dcv/queue/04-no-ingress-dcv.html). Keep in mind performance will be slower over an SSM pipe.
{{% /notice %}}

The first step is to create a security group that allows you to connect to the compute nodes on port `8443`. We'll use this later in the [AdditionalSecurityGroups](https://docs.aws.amazon.com/parallelcluster/latest/ug/Scheduling-v3.html#yaml-Scheduling-SlurmQueues-Networking-AdditionalSecurityGroups) section of the queue.

1. Go to [EC2 Security Group Create](https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#CreateSecurityGroup:) 
* **Name:** DCV
* Add an Ingress rule, `Custom TCP`, `Port 8443`, `0.0.0.0/0`
* **Description** Allow connecting to the compute nodes via DCV

![image](/images/nice-dcv/dcv-security-group.png)

2. Leave the outbound rules the same, save the **Security Group**.