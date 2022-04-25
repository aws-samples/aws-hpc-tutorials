+++
title = "2. Install Docker"
date = 2019-09-18T10:46:30-04:00
weight = 45
tags = ["tutorial", "install", "AWS", "batch", "Docker", "ECR"]
+++

You can find the instructions to install docker by following [this guide](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/docker-basics.html#install_docker) and ensure that the pre-requisites shown on [this page](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/docker-basics.html#use-ecr) are fulfilled. You will also step through it below

1. **Update** the installed packages and package cache on your instance.
```bash
sudo yum update -y
````
2. **Install** the most recent Docker Engine package.
```bash
sudo amazon-linux-extras install docker
```
3. **Start** the Docker service.
```bash
sudo service docker start
```
4. **Add** the ec2-user to the docker group so you can execute Docker commands without using sudo.
```bash
sudo usermod -a -G docker ec2-user
```
5. **Log out and log back in** to pick up the new docker group permissions. You can accomplish this by closing your current SSH terminal window and reconnecting to your instance in a new one. Your new SSH session will have the appropriate docker group permissions.

6. **Verify** that the ec2-user can run Docker commands without sudo. 
```bash
docker info
```
![EC2 instance create](/images/aws-batch/deep-dive/terminal_2.png)


##### Build the container image and upload it to Amazon ECR:
Now that your instance is ready and docker is installed it is time to build the container and upload it to Amazon ECR:

1. **Create** a new file called Dockerfile in your current working directory.
2. **Open** the file and **write** the content below:
```bash
FROM public.ecr.aws/amazonlinux/amazonlinux:2
RUN amazon-linux-extras install epel -y && yum install stress-ng -y
CMD /usr/bin/stress-ng
```
3. **Save** the file.![EC2 instance create](/images/aws-batch/deep-dive/terminal_3.png)

4. **Run** the commands below to build and push the container image to the Amazon ECR repository you created when deploying the Batch CloudFormation stack. 
	- *If running on your own workstation, ensure that the account ID and region are properly set for the environment variables `AWS_ACCOUNT_ID` and `AWS_REGION`.* If further guidance is needed, follow this [guide](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/docker-basics.html#use-ecr).


```bash
#!/bin/bash

# set environment variables
AWS_ACCOUNT_ID=`curl -s http://169.254.169.254/latest/dynamic/instance-identity/document|grep accountId| awk '{print $3}'|sed  's/"//g'|sed 's/,//g'` # or replace by your account ID
AWS_REGION=`curl -s http://169.254.169.254/latest/dynamic/instance-identity/document|grep region| awk '{print $3}'|sed  's/"//g'|sed 's/,//g'` # or replace by your region ID
ECR_URL=`aws cloudformation describe-stacks --stack-name BatchStack --query "Stacks[0].Outputs[?OutputKey=='ECRRepositoryUrl'].OutputValue" --output text --region ${AWS_REGION}`

# Authenticate with ECR
aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

# Build the image
docker build -t stress-ng .

# Tag the image
docker tag stress-ng:latest ${ECR_URL}:latest

# Push your image to your ECR repository
docker push ${ECR_URL}:latest
```

![EC2 instance create](/images/aws-batch/deep-dive/terminal_4.png)
5. **Confirm** that the stress-ng container has been added to the Amazon ECR.![EC2 instance create](/images/aws-batch/deep-dive/Amazon_ECR.png)


#### Next Steps
By now, you should have

1. Deployed your network environment
2. Deployed your AWS Batch environment
3. Created the container image that will be used to run your batch jobs.

Now you will now run a test workload in AWS Batch to evaluate its behavior.

