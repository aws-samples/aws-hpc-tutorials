+++
title = "f. Opt - Create an EC2 Instance"
weight = 100
tags = ["tutorial", "cloud9", "aws cli", "ec2", "s3"]
+++

In this section, you create an SSH key-pair on your AWS Cloud9 instance, create an Amazon EC2 instance, then access it.

#### Generate an SSH Key-pair

SSH is [commonly](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AccessingInstancesLinux.html) used to connect to Amazon EC2 instances. To allow you to connect to your instances, you can generate a key-pair using the AWS CLI in your AWS Cloud9 instance. This example uses the key name **lab-2-your-key** but you can change the name of your key.
Enter the following command to generate a key pair:

```bash
aws ec2 create-key-pair --key-name lab-2-your-key --query KeyMaterial --output text > ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa
```

Optionally, use the following command to check if your key is registered:

```bash
aws ec2 describe-key-pairs
```

#### Create a New Amazon EC2 Instance

When you create an EC2 instance, you need to place it in an Amazon Virtual Private Cloud (VPC). As a first step, identify the VPC and subnet of the AWS Cloud9 instance so you can place the EC2 instance in the same location.

1. Use the following command to find the **Subnet ID** and **VPC ID** of the Cloud9 instance. You use this information in the next step to launch an instance.

```bash
MAC=$(curl -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/)
cat << EOF
***********************************************************************************
Subnet ID = $(curl -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/$MAC/subnet-id)
VPC ID = $(curl -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/$MAC/vpc-id)
************************************************************************************
EOF
```
2. In the AWS Management Console, navigate to the **EC2 Dashboard**, then to the **Instances** section.
3. Choose **Launch Instance**.
![EC2 Dashboard](/images/introductory-steps/ec2-details.png)
4. Choose the **Amazon Linux 2 AMI** and click **Select**.
5. Select the **t2.micro** instance then choose **Next: Configure Instance Details**.
6. In the **Network** section, select the same **VPC ID** and same **Subnet ID** from your AWS Cloud9 Instance.
7. Choose **Next: Add Storage** and leave the **Storage** section default settings.
8. Choose **Next: Add Tags**.
9. Choose **Add Tag** then as a **Key** input **Name** (literally, not your name!). For **Value**, add **[Your Name]'s Instance** or any significant name. This name appears as the name of your instance.
![EC2 Tags](/images/introductory-steps/ec2-tags.png)
10. Choose **Next: Configure Security Groups**.
11. Select the **Create a new security group** check box, and if desired, change the **Security Group** name. The type should be **ssh**, protocol **TCP**, port range **22** and the source **0.0.0.0/0**.
12. Choose **Review and Launch**. Ignore any warnings messages.
13. On the review page, choose **Launch**, then select the **lab-2-your-key** key-pair you created earlier.
![EC2 Tags](/images/introductory-steps/ec2-key.png)

Your instance is being launched! To check the status, view the **Instances** section of the **EC2 Dashboard**.

#### Connect to Your Instance

{{% notice info %}}
If you are having issues connecting to your instance, navigate to the [EC2 Dashboard](https://console.aws.amazon.com/ec2) in the AWS Management Console. Select your instance and review its details. See also the troubleshooting section at the bottom of this page.
{{% /notice %}}

After the instance is running, follow these steps:
1. Navigate to the AWS Cloud9 environment and open a terminal window.
2. Use the following command to list running instances and display their names, type, private IP address, and public IP address. Here, the information is filtered to only keep certain details (hence the complex command). The same information is displayed on the [EC2 Dashboard](https://console.aws.amazon.com/ec2).
```bash
aws ec2 describe-instances --query 'Reservations[*].Instances[*].[Tags[?Key==`Name`]| [0].Value,InstanceType, PrivateIpAddress, PublicIpAddress]' --filters Name=instance-state-name,Values=running --output table
```
2. Connect to your instances with **SSH** using either the public or private **IP address** and the username **ec2-user** which is the default user for Amazon Linux. Type **yes** when asked if you want to connect to the instance.
{{% notice info %}}
Make sure to select the IP address of the instance you want to connect to and not the example IP address shown.
{{% /notice %}}
```bash
# don't forget to use your OWN ip address
# keep the username to ec2-user as is, don't use your name!
ssh ec2-user@10.0.1.6
```
3. Ping the internet to test the outbound connectivity.
```bash
ping www.wikipedia.org
```

You now have an functional instance that can communicate with the outside world! Continue to the next section to see what else you can do.

![EC2 SSH](/images/introductory-steps/ec2-ssh.png)

#### Troubleshooting Instance Connections

There could be two primary reasons why you cannot connect to your instance:
- You are using the wrong EC2 key-pair. Verify that your private and public key-pair are matching, if not, create an instance with the proper key-pair or generate a new one and start a new instance with it.
- The security group does not allow SSH traffic to reach the instance. See the AWS support page on [this subject](https://aws.amazon.com/premiumsupport/knowledge-center/ec2-linux-ssh-troubleshooting/).



