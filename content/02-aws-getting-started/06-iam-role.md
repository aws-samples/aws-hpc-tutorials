+++
title = "d. Attach Role to Cloud9 Instance"
date = 2019-09-18T10:46:30-04:00
weight = 80
tags = ["tutorial", "install", "IAM"]
+++

In this step, you will create an [IAM](https://aws.amazon.com/iam/) role with Administrator access and configure Cloud9 to use the IAM role for the rest of this lab.

AWS Identity and Access Management (IAM) enables you to manage access to AWS services and resources securely.
Using IAM, you can create and manage AWS users and groups, and use permissions to allow and deny their access to AWS resources.

By configuring Cloud9 to use the IAM role, you will allow your Cloud9 instance to access any services of your AWS account.


1. Follow [this link to create an IAM role with Administrator access](https://console.aws.amazon.com/iam/home#/roles$new?step=review&commonUseCase=EC2%2BEC2&selectedUseCase=EC2&policies=arn:aws:iam::aws:policy%2FAdministratorAccess).

2. Confirm that **AWS service** and **EC2** are selected, then click **Next: Permissions** to view permissions.

3. Confirm that **AdministratorAccess** is checked, then click **Next: Tags** to assign tags.

4. Take the defaults, and click **Next: Review** to review.

5. Enter **hpcworkshop-admin** for the Name, and click **Create role**. 
![Getting Started](/images/introductory-steps/iam-role-1.png)

6. Follow [this link to find your Cloud9 EC2 instance](https://console.aws.amazon.com/ec2/v2/home?#Instances:search=cloud9;sort=desc:launchTime).

7. Select the Cloud9 instance.
8. For **Actions**, choose **Security**, select **Modify IAM Role**.


![Getting Started](/images/introductory-steps/iam-role-2.png)

9. For **IAM Role**, choose **hpcworkshop-admin**.
10. Choose **Save**.
![Getting Started](/images/introductory-steps/iam-role-3.png)

11. In Cloud9, choose the gear icon in top right corner to open a new tab and choose "Preferences” tab.

12. In the Preferences tab, choose **AWS SETTINGS** to turn off **AWS managed temporary credentials**, then close the Preferences tab.

![Getting Started](/images/introductory-steps/cloud9-credentials.png)

13. Identify the AWS region with the following commands:

```bash
export AWS_REGION=$(curl --silent http://169.254.169.254/latest/meta-data/placement/region)
echo $AWS_REGION
```

14. Configure the AWS CLI to use this AWS region:

```bash
aws configure set default.region ${AWS_REGION}
aws configure get default.region
```
