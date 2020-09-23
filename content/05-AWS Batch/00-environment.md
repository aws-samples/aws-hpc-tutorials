+++
title = "a. Lab Environment"
date = 2019-09-18T10:46:30-04:00
weight = 20
tags = ["tutorial", "install", "AWS", "Batch"]
+++

In this step, we will create an IAM role with Administrator access, then launch an EC2 instance with the IAM role for the rest of this lab.

1. Follow [this deep link to create an IAM role with Administrator access](https://console.aws.amazon.com/iam/home#/roles$new?step=review&commonUseCase=EC2%2BEC2&selectedUseCase=EC2&policies=arn:aws:iam::aws:policy%2FAdministratorAccess).

2. Confirm that **AWS service** and **EC2** are selected, then click **Next: Permissions** to view permissions.

3. Confirm that **AdministratorAccess** is checked, then click **Next: Tags** to assign tags.

4. Take the defaults, and click **Next: Review** to review.

5. Enter **hpcworkshop-admin** for the Name, and click **Create role**. 
![AWS Batch](/images/aws-batch/iam-role-1.png)

6. Launch an EC2 instance with an **Amazon Linux 2** AMI. In ***Step 3: Configure Instance Details*, locate **IAM role** and select the newly created **hpcworkshop-admin** from the drop-down selections.
![AWS Batch](/images/aws-batch/iam-role-2.png)

7. Wait for the EC2 instance to become **running**, then SSH into the EC2 instance with username **ec2-user**. 

