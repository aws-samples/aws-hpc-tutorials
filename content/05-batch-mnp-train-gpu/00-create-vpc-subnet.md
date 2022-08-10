---
title : "a. Create VPC and Subnets using Wizard"
date: 2022-07-22T15:58:58Z
weight : 10
tags : ["configuration", "vpc", "subnet", "wizard"]
---

{{% notice info %}}
If you already have a VPC, Private Subnet w/ NAT Gateway and Public Subnet w/ IGW, please skip the step and proceed to the next step 
{{% /notice %}}

In this step, you create the VPC, Private Subnet w/ NAT Gateway and a Public Subnet with the Internet Gateway (IGW). We will use the VPC wizard to set this up very quickly from the console.

#### Create VPC, Private and Public Subnet

1. Log into your AWS Console
2. Go to VPC and Create a VPC
3. Use the option "VPC and more" to automatically create the Subnet in the correct zonea and the NAT/Internet Gateways
4. Set the options as shown in the figure below. In this case we are setting
    - IPv4 CIDR block
    - 1 AZ and selecting a specific availability zone
    - 1 Public Subnet and 1 Private Subnet
![VPC Options](/images/batch_mnp/vpc_wizard_options.png)
5. The tree view shows the different entities that will be created graphically
![VPC Tree](/images/batch_mnp/vpc_wizard_tree.png)
6. Verify the VPC and Subnets created in the AWS Console. We would be be using their id's to create the Cloud9, Elastic File System and AWS Batch Environment in the next step
![VPC Console View](/images/batch_mnp/vpc_subnet_console_view.png)

