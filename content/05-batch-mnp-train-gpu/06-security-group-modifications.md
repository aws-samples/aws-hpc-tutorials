---
title : "f. Modifications to Security Group for NCCL + Communication"
date: 2022-07-22T15:58:58Z
weight : 70
tags : ["configuration", "vpc", "subnet", "iam", "pem"]
---

In this step, you will make modifications to the security group so that it will permit non-TCP connections between the nodes. This is useful for nodes that have EFA based communication between the nodes.

### Security Group Modifications

Edit the inbound and outbound rules of the security group to permit All Traffic, All Protocols, All Ports from the source as the "same" security group. Though this seems obvious, it is essential to permit the instances to communicate with each other other than TCP.

- Inbound Rules Modification
![Inbound Rules](/images/batch_mnp/sg_inbound_rules.png)

- Outbound Rules Modification
![Outbound Rules](/images/batch_mnp/sg_outbound_rules.png)
