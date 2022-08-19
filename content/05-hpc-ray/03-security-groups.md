---
title: "b. Security Groups"
date: 2022-08-18
weight: 40
tags: ["Ray", "Security Groups"]
---

The default security group in a VPC does not have ssh permission which is needed by the head node to connect to the worker nodes. Also, also need a security group with permissions to mount FSx filesystem. It is straight forward to create security groups from the AWS EC2 console.

Create a security group with the following inbound rules and call it **ray-cluster-sg**:

![ray-cluster-sg-inbound-rules](/images/hpc-ray-workshop/ray-cluster-sg-inbound-rules.png)

Leave the outbound rules as default.

Next, create a security group for FSxL with the following inbound/outbound rules and call it **ray-fsx-sg**:

![ray-fsx-sg-inbound-rules](/images/hpc-ray-workshop/ray-fsx-sg-inbound-rules.png)

Again, leave the outbound rules as default.
