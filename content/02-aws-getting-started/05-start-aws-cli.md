+++
title = "c. Work with the AWS CLI"
weight = 70
tags = ["tutorial", "cloud9", "aws cli", "s3"]
+++

Your AWS Cloud9 Environment should be ready. Now, you can become familiar with the environment, learn about the AWS CLI, and then create an Amazon S3 bucket with the AWS CLI. This S3 bucket is used in the next module. 

#### AWS Cloud9 IDE Layout

The AWS Cloud9 IDE is similar to a traditional IDE you can find on virtually any system. It comprises the following components:

- file browser, listing the files located on your instances. 
- opened files in tab format, located at the top 
- terminal tabs, located at the bottom. 

AWS Cloud9 also includes the latest version of AWS CLI, but it is always a good practice to verify you are using the latest version. You can verify the AWS CLI version by following the next section. 
 

![Cloud9 First Use](/images/introductory-steps/cloud9-first-use.png)

### Install AWS CLI version 2 and some software utilities 

The [AWS CLI](https://aws.amazon.com/cli/) allows you to manage services using the command line and control services through scripts. Many users choose to conduct some level of automation using the AWS CLI.

{{% notice tip %}}
Use the copy button in each of the following code samples to quickly copy the command to your clipboard.
{{% /notice %}}

In your AWS Cloud9 terminal window paste the following commands

1. Clean-up any exsisting aws cli installation

```bash
sudo pip uninstall -y awscli
```

2. Install AWS CLI 2.x

```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
. ~/.bash_profile
```

3. Verify you have AWS CLI 2.x

```bash
aws --version
```

4. Install jq utility ( you will need this utility to work with JSON files in the labs that follow )

```bash
sudo yum install -y jq 
```
