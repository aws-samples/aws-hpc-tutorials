+++
title = "a. Lab Environment"
date = 2019-09-18T10:46:30-04:00
weight = 20
tags = ["tutorial", "install", "AWS", "Batch"]
+++

This section modifies the Cloud9 environment that you created in the [Getting Started in the Cloud](/02-aws-getting-started.html) workshop in the following ways:

- Expand the root volume to at least 20GiB in capacity to allow container images to be built locally.
- Upgrade to [AWS Command Line Interface (AWS CLI) Version 2](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html) in order to upload your container images to [Amazon Elastic Container Registry (ECR)](hhttps://aws.amazon.com/ecr/).

### Expand Cloud9 Root Volume
In this first step you will ensure the root volume of your Cloud9 instance has at least 20GiB capacity in order for Docker images to be built locally.

1. Open the Amazon EC2 console [link](https://console.aws.amazon.com/ec2/v2/home?#Instances:search=cloud9;sort=desc:launchTime) to find your Cloud9 instance.
2. Stop the instance if is running by selecting the instance and choosing **Instance state / Stop instance /**. ![Stop running instance](/images/aws-batch/root-volume-1.png)
3. Choose the storage tab and select the Volume ID for the root volume. ![Click on the Storage tab](/images/aws-batch/root-volume-2.png)
4. For actions, choose **Modify Volume** and for **Size** enter 20GiB. ![Modify the root volume](/images/aws-batch/root-volume-3.png)
5. Return to your [ Cloud9 EC2 instance](https://console.aws.amazon.com/ec2/v2/home?#Instances:search=cloud9;sort=desc:launchTime) and start it up by selecting the instance and choosing **Instance state / Start instance /**.
6. Open your [Cloud9 instance](https://console.aws.amazon.com/cloud9/home).

### Upgrade to AWS CLI Version 2

AWS CLI Version 2 is required to interact with [Amazon ECR](https://aws.amazon.com/ecr/). You will install it by copying, pasting, and executing the following instructions in the terminal window at the bottom of your Cloud9 IDE window.
1.  Execute the following commands to upgrade to AWS CLI to Version 2. More information on this process is available at https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html. 
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install -i /usr/local/aws-cli -b /usr/bin
aws --version
```
After executing ther commands above, confirm that you now have AWS CLI version 2 sucessfully installed by verfying output from the last command above results in output similar to the following:
```text
aws-cli/2.5.7 Python/3.9.11 Linux/4.14.273-207.502.amzn2.x86_64 exe/x86_64.amzn.2 prompt/off
```

### Install JQ
To help with commands results slicing and filtering.
```bash
sudo yum -y install jq 
```
