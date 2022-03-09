+++
title = "b. IAM Role Setup"
date = 2019-09-18T10:46:30-04:00
weight = 20
tags = ["tutorial", "install", "AWS", "Batch"]
+++

The main account owner must complete the following steps to create a Role with administrative access and assign that Role to the Cloud9 instance.

### Create IAM role with Administrator Access

In this step, you will create an IAM Role and assign it administrative access permissions (via a Policy), and then configure your Cloud9 to use that Role for the remainder of this workshop.

1. Open the IAM console [link](<https://console.aws.amazon.com/iam/home#/roles%24new?step=type&commonUseCase=EC2%2BEC2&selectedUseCase=EC2&policies=arn:aws:iam::aws:policy%2FAdministratorAccess>) to create an IAM Role.
2. Confirm that **AWS service** and **EC2** are selected, then click **Next: Permissions** to view permissions.
![AWS Batch](/images/aws-batch/iam-role-1.png)
1. Confirm that **AdministratorAccess** is checked, then click **Next: Tags**.
![AWS Batch](/images/aws-batch/iam-role-2.png)
4. Keep the defaults, and click **Next: Review** to review.
5. For **Role name**, enter **cloud9-hpcworkshop-admin**
![AWS Batch](/images/aws-batch/iam-role-3.png)
6. Choose  **Create role**. 


### Associate the IAM Role with the Cloud9 Instance

1. Open the Amazon EC2 [link](<https://console.aws.amazon.com/ec2/v2/home#Instances:tag:Name=aws-cloud9-myCloud9Env>) to find your Cloud9 instance.
2. Select the Cloud9 instance.   
3. For **Actions**, choose **Security**, select **Modify IAM Role**. 
![AWS Batch](/images/aws-batch/iam-role-4.png)
4. For the new **IAM Role**, choose **cloud9-hpcworkshop-admin**
![AWS Batch](/images/aws-batch/iam-role-5.png)
5. Select **Save**. 


### Disable AWS Managed Temporary Credentials
1. Open your Cloud9 environment, and click on the top edge of the content pane to show the Cloud9 menu if not visible.
2. Choose the **gear icon** in top right corner to open the **Preferences** tab.
3. In the **Prefereneces** tab, choose **AWS SETTINGS**. 
4. Turn off **AWS managed temporary credentials**
![AWS Batch](/images/aws-batch/iam-role-6.png)
5. Close the **Preferences** tab.

1. Remove any existing credentials file by copying, pasting and executing the following commands in a terminal on your Cloud9 instance.
```bash
rm -vf ${HOME}/.aws/credentials
```
7. Configure the AWS CLI to use the current AWS region:
```bash
export AWS_REGION=$(curl --silent http://169.254.169.254/latest/meta-data/placement/region)
aws configure set default.region ${AWS_REGION}
aws configure get default.region
```
