+++
title = "d. Create a Key Pair"
weight = 75
tags = ["tutorial", "cloud9", "aws cli", "ec2", "key-pair"]
+++

In this section, you create an SSH key-pair on your AWS Cloud9 instance, which you can use for EC2 instance and Parallel Cluster creation.

#### Generate an SSH Key-pair

SSH is [commonly](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AccessingInstancesLinux.html) used to connect to Amazon EC2 instances. To allow you to connect to your instances, you can generate a key-pair using the AWS CLI in your AWS Cloud9 instance. This example uses the key name **lab-your-key** but you can change the name of your key.
Enter the following command to generate a key pair:

```bash
aws ec2 create-key-pair --key-name lab-your-key --query KeyMaterial --output text > lab-your-key.pem
chmod 600 lab-your-key.pem
```

Optionally, use the following command to check if your key is registered:

```bash
aws ec2 describe-key-pairs
```
