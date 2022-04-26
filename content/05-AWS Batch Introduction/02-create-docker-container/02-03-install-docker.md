+++
title = "2. Install Docker"
date = 2019-09-18T10:46:30-04:00
weight = 45
tags = ["tutorial", "install", "AWS", "batch", "Docker", "ECR"]
+++

In this step, you will create an instance to build a container and push it to Amazon ECR. 

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
{{% notice info %}}
**Skip** step 4 & 5 if using *Cloud9*. Go directly to step 6.
{{% /notice %}}

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

Now you have successfully installed Docker. Let us continue to the next section to build and push the container.
