+++
title = "b. Create a key pair"
date = 2023-04-10T10:46:30-04:00
weight = 20
tags = ["tutorial", "ssh"]
+++

{{% notice info %}}This lab requires an AWS Cloud9 IDE. If you do not have an AWS Cloud9 IDE set up, complete the steps in *c. Open a Cloud9 Environment* and *d. Work with the AWS CLI* in the **[Preparation](/02-aws-getting-started.html)** section.
{{% /notice %}}

In this section, you create an SSH key-pair on your AWS Cloud9 instance, which you can use as a terminal and IDE for EC2 instance and Parallel Cluster creation.

#### Connect to Cloud9 Instance

In the AWS Management Console search bar, type and select **[Cloud9](https://console.aws.amazon.com/cloud9/home)**. 
![search-cloud9](/images/hpc-aws-parallelcluster-workshop/lab1-pcluster-workshop-03-cloud9_search.png)

Choose **open IDE** for the Cloud9 instance set up previously. It may take a few moments for the IDE to open. AWS Cloud9 stops and restarts the instance so that you do not pay compute charges when no longer using the Cloud9 IDE. 

![open-ide](/images/hpc-aws-parallelcluster-workshop/lab1-pcluster-workshop-03-cloud9_OpenIDE.png)

A new tab will open with your AWS Cloud9 environment, which will be ready in a few minutes.

![Cloud9 Create](/images/introductory-steps/cloud9-create.png)

Use the terminal at the bottom half of the Cloud9 IDE to enter any required commands.

To ease finding configuration files later, navigate to the home directory (`/home/ec2-user`) by just running the command `cd` or:

```bash
cd /home/ec2-user
```

#### Generate an SSH Key-pair
SSH is **[commonly](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AccessingInstancesLinux.html)** used to connect to Amazon EC2 instances. To allow you to connect to your instances, you can generate a key-pair using the AWS CLI in your AWS Cloud9 instance. This example uses the key name **lab-your-key** but you can change the name of your key. Enter the following command to generate a key pair:

```bash
aws ec2 create-key-pair --key-name lab-your-key --query KeyMaterial --output text > lab-your-key.pem
chmod 600 lab-your-key.pem
```

Next add it to the `~/.bashrc` file, this allows us to reference it later:

```
echo "export AWS_KEYPAIR=lab-your-key" >> ~/.bashrc
source ~/.bashrc
```

Optionally, use the following command to check if your key is registered:

```
aws ec2 describe-key-pairs
```

Next, you will install AWS ParallelCluster.