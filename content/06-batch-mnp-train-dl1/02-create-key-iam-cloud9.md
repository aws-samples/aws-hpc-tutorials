---
title : "c. Create EC2 pem key pair, IAM roles and Cloud9 Console"
date: 2022-07-22T15:58:58Z
weight : 30
tags : ["configuration", "vpc", "subnet", "iam", "pem"]
---

In this step, you create the EC2 pem key along with the IAM profiles needed for the AWS Batch. 

### Create EC2 Pem Key Pair

{{% notice info %}}
You can reuse your pem key if you already have one and do not have to create a new one.
{{% /notice %}}

The PEM key is essential for the users to ssh into their instance post their creation to monitor or troubleshoot issues in the nodes. [Create a KeyPair](https://docs.aws.amazon.com/batch/latest/userguide/get-set-up-for-aws-batch.html#create-an-iam-role) documents the steps to create a keypair.

**You can reuse your pem key if you already have one and do not have to create a new one.**


### Create the AWSBatchServiceRole, Instance and ECSTaskExecution Roles

The AWS Batch compute environment and container instance roles are automatically created for you in the console first-run experience, so if you intend to use the AWS Batch console, you can move ahead to the next section. If you plan to use the AWS CLI instead, complete the procedures in 
- [AWS Batch service](https://docs.aws.amazon.com/batch/latest/userguide/service_IAM_role.html) for the Batch service to launch instances into the compute environment, setup auto scaling groups etc.
- [AWS Instance Role](https://docs.aws.amazon.com/batch/latest/userguide/instance_IAM_role.html) for the instance to make calls to several AWS API's on your behalf.
- [AWS ECS Task Execution Role](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_execution_IAM_role.html) for the task to make calls to several AWS API's on your behalf


### Create Cloud9 Console

In order to get an environment where you can build containers, we need a Cloud9 IDE. Since we are using the Cloud 9 to build/push containers and log into our cluster, we need to select the reasonably sized instance located in an appropriate subnet. 

At a high level,
- Create a new Cloud9 Instance and select a c5.2xlarge as the instance
- Launch it in the **VPC and Public Subnet you created in the previous step**
The steps to create the Cloud9 instance is detailed in [Cloud9 Creation](https://www.hpcworkshops.com/02-aws-getting-started/04-start_cloud9.html)

- The default Storage attached to Cloud9 (10GB) is not sufficient to build the containers, Follow the steps in [Resize EBS](https://catalog.us-east-1.prod.workshops.aws/workshops/4522540d-c97b-482b-9725-3f5ce058e6b8/en-US/prerequisites/05-grow-fs) to use the script to resize the volume to 100 GB. The script above automates the sequence of steps to identify the root volume and increase the size

- After increasing the size, check the disk space
```bash
$ df -h
Filesystem       Size  Used Avail Use% Mounted on
udev             7.6G     0  7.6G   0% /dev
tmpfs            1.6G  824K  1.6G   1% /run
/dev/nvme0n1p1    97G  8.2G   89G   9% /
tmpfs            7.6G     0  7.6G   0% /dev/shm
tmpfs            5.0M     0  5.0M   0% /run/lock
tmpfs            7.6G     0  7.6G   0% /sys/fs/cgroup
/dev/loop0        56M   56M     0 100% /snap/core18/2538
/dev/loop1        26M   26M     0 100% /snap/amazon-ssm-agent/5656
/dev/loop2        56M   56M     0 100% /snap/core18/2409
/dev/loop3        47M   47M     0 100% /snap/snapd/16292
/dev/nvme0n1p15  105M  4.4M  100M   5% /boot/efi
tmpfs            1.6G     0  1.6G   0% /run/user/1000
mahaaws_full:~/environment $ 
```
- The Cloud9 IDE comes with a default aws cli. However, it is always better to update it to the latest cli. Follow the steps in [Update AWS CLI](https://www.hpcworkshops.com/02-aws-getting-started/05-start-aws-cli.html) to update the aws cli and run a sample cli to list the ec2 instances and keypairs in your account.
