---
title: "b. Create IAM Roles"
date: 2022-08-18
weight: 30
tags: ["Ray", "IAM"]
---

By default, Ray creates an IAM role with some managed policies and attaches it to the head node at the cluster creation time. No role is created for the worker node. But, to have a more granular control over policies and permissions for both the head and work nodes, we will create two IAM roles (ray-head, ray-worker) to be used at the cluster creation time.

In order to create an IAM role from command line, we need to define a trust policy. Save the following trust policy to **ray_trust_policy.json** file:

```json
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
```

Execute the following commands to create the IAM role for the head node and also the instance profile for this role:

```bash
aws iam create-role --role-name ray-head --assume-role-policy-document file://ray_trust_policy.json
aws iam create-instance-profile --instance-profile-name ray-head
aws iam add-role-to-instance-profile --instance-profile-name ray-head --role-name ray-head
```

Next, execute the following commands to create the IAM role for worker nodes and also the instance profile for this role:

```bash
aws iam create-role --role-name ray-worker --assume-role-policy-document file://ray_trust_policy.json
aws iam create-instance-profile --instance-profile-name ray-worker
aws iam add-role-to-instance-profile --instance-profile-name ray-worker --role-name ray-worker
```

The head and worker nodes need permission to access S3, FSxL and CloudWatch. So we will attache the relevant managed policies to these roles. Apart from this, the head node also need to able to spin up EC2 instances.

Following commands attach the necessary policies to the IAM role for the head node:

```bash
aws iam attach-role-policy --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess --role-name ray-head
aws iam attach-role-policy --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess --role-name ray-head
aws iam attach-role-policy --policy-arn arn:aws:iam::aws:policy/AmazonFSxFullAccess --role-name ray-head
aws iam attach-role-policy --policy-arn arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy --role-name ray-head
aws iam attach-role-policy --policy-arn arn:aws:iam::aws:policy/AmazonSSMFullAccess --role-name ray-head
```
Apart from these manages policies, we also need to give permission to the head node to pass an IAM role to ec2 instances. Save the following policy to **ray_pass_role_policy.json**:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "iam:PassRole"
            ],
            "Resource": [
              "arn:aws:iam::*:role/ray-worker"
            ]
        }
    ]
}
```

Now, attache this policy to the ray-head role:

```bash
aws iam put-role-policy --role-name ray-head --policy-name ray-pass-role-policy --policy-document file://ray_pass_role_policy.json
```

We would need the Arns for the instance profiles for these roles later when creating the cluster. Execute the following to get these arns:

```
aws iam get-instance-profile --instance-profile-name ray-head --o text --query 'InstanceProfile.Arn'
aws iam get-instance-profile --instance-profile-name ray-worker --o text --query 'InstanceProfile.Arn'
```
