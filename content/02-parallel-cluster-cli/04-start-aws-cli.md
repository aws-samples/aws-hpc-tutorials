+++
title = "c. Work with the AWS CLI"
weight = 25
tags = ["tutorial", "cloud9", "aws cli", "s3"]
+++

Your AWS Cloud9 Environment should be ready. Now, you can become familiar with the environment, learn about the AWS CLI.

#### AWS Cloud9 IDE Layout

The AWS Cloud9 IDE is similar to a traditional IDE you can find on virtually any system. It comprises the following components:

- file browser, listing the files located on your instances. 
- opened files in tab format, located at the top 
- terminal tabs, located at the bottom. 

AWS Cloud9 also includes the latest version of AWS CLI, but it is always a good practice to verify you are using the latest version. You can verify the AWS CLI version by following the next section. 
 

![Cloud9 First Use](/images/introductory-steps/cloud9-first-use.png)

### Update the AWS CLI

The [AWS CLI](https://aws.amazon.com/cli/) allows you to manage services using the command line and control services through scripts. Many users choose to conduct some level of automation using the AWS CLI.

{{% notice tip %}}
Use the copy button in each of the following code samples to quickly copy the command to your clipboard.
{{% /notice %}}

First we need to upgrade the version of the `aws` cli:

```bash
sudo yum remove -y awscli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
exit
```

If that worked open a new terminal and run `aws --version` and you shoudl see version >= 2.

```bash
$ aws --version
aws-cli/2.7.10 Python/3.9.11 Linux/4.14.281-212.502.amzn2.x86_64 exe/x86_64.amzn.2 prompt/off
```

### Check Existing Amazon EC2 Instances

Use the following commands to display:

- the general AWS CLI help, 
- the help related to Amazon EC2 commands, 
- the list of your existing instances with their key characteristics and 
- the list of your registered SSH key-pairs. 

```bash
aws help
```
Type **q** to exit the help pages.
```bash
aws ec2 help
```
Type **q** to exit the help pages.
```bash
aws ec2 describe-instances
```
```bash
aws ec2 describe-key-pairs
```

Next, you use the AWS CLI to create a key-pair, launch EC2 instance, and interact with Amazon S3.
