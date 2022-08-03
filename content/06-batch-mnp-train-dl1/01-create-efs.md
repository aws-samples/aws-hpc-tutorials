---
title : "b. Create EFS for Sharing Data"
date: 2022-07-22T15:58:58Z
weight : 20
tags : ["configuration", "vpc", "subnet", "efs"]
---

In this step, you create the EFS volume in same zone we created the subnet in the last step.

**Note: If you already have an EFS that could be mounted within the VPC, you can skip the step and proceed to the next step.**

#### Create One Zone EFS

1. Select EFS inside your AWS Console login
2. Click on "Create EFS" and set the following options
    - Name for the EFS Volume
    - Select the VPC from the previous step
    - Ensure that you select One Zone EFS. You could also create it in multiple AZ's if you plan to use training instances in Multiple AZ's
    - Select the appropriate zone
    ![EFS Dialog](/images/batch_mnp/efs_create_dialog.png)
3. Verify the EFS created and this will create a security group that would be the default for this VPC. Since this is the default security group for the VPC, any instance launched with this security group will be able to mount the EFS volume.
    ![EFS Details](/images/batch_mnp/efs_with_sg.png)
4. The instructions to attach the EFS is also available in the "Attach Volume". This would present the instructions for mounting the EFS through both DNS and IP.
    ![EFS Mount](/images/batch_mnp/efs_attach_instructions.png)

5. In the next steps we will use the following to create the "user data" for the launch template to create instances automatically into the cluster
    - VPC & Subnet
    - EFS Mount instructions
    - Security Groups