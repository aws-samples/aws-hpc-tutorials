+++
title = "b. Connect to NICE DCV EC2 Instance"
date = 2019-01-24T09:05:54Z
weight = 160
tags = ["HPC", "NICE", "Visualization", "Remote Desktop", "Web Browser", "Native Client"]
+++

In this section, you connect to your NICE DCV EC2 instance, setup password required for DCV Remote Desktop Session and launch a DCV Session. You will do all this on AWS Cloud9 terminal.

#### Connect to your instance 

{{% notice info %}}
If you are having issues connecting to your instance, navigate to the [EC2 Dashboard](https://console.aws.amazon.com/ec2) in the AWS Management Console. Select your instance and review its details. See also the troubleshooting section at the bottom of this page.
{{% /notice %}}

After the instance is running, follow these steps:

1. Navigate to the AWS Cloud9 environment and open a terminal window.

2. Use the following command to list running instances and display their names, type, private IP address, and public IP address. Here, the information is filtered to only keep certain details (hence the complex command). The same information is displayed on the [EC2 Dashboard](https://console.aws.amazon.com/ec2).

```bash
aws ec2 describe-instances --query 'Reservations[*].Instances[*].[Tags[?Key==`Name`]| [0].Value,InstanceType, PrivateIpAddress, PublicIpAddress]' --filters Name=instance-state-name,Values=running --output table
```

You'll see the following:

![NICE DCV EC2Launch](/images/nice-dcv/ec2_instances.png)

3. Connect to your instances with **SSH** using either the public or private **IP address** and the username **ec2-user** which is the default user for Amazon Linux. Type **yes** when asked if you want to connect to the instance.
{{% notice info %}}
Make sure to select the IP address of the instance you want to connect to and not the example IP address shown.

{{% /notice %}}
```bash
# don't forget to use your OWN ip address
# keep the username to ec2-user as is, don't use your name!
ssh -i lab-your-key ec2-user@3.239.217.95
```

4. Ping the internet to test the outbound connectivity.
```bash
ping www.wikipedia.org
```

You now have an functional instance that can access the internet.

#### Troubleshooting Instance Connections

There could be two primary reasons why you cannot connect to your instance:
- You are using the wrong EC2 key-pair. Verify that your private and public key-pair are matching, if not, create an instance with the proper key-pair or generate a new one and start a new instance with it.
- The security group does not allow SSH traffic to reach the instance. See the AWS support page on [this subject](https://aws.amazon.com/premiumsupport/knowledge-center/ec2-linux-ssh-troubleshooting/).

#### Setup Password for DCV Remote Desktop Session

Set the password for **ec2-user** as below. Note, this is the **password** that you will use when prompted while connecting to the DCV Remote Desktop Session.

```bash
[ec2-user@ip-172-31-7-241 ~]$ sudo passwd ec2-user
Changing password for user ec2-user.
New password:
Retype new password:
passwd: all authentication tokens updated successfully.
[ec2-user@ip-172-31-7-241 ~]$
``` 

#### Launch a DCV session

Create a virtual session to connect to. Note, **dcvdemo** below is your **session name**, you can modify as you want. We will use this **session name** while connecting to Remote Desktop. 

```bash
dcv create-session dcvdemo
```

 

