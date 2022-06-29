+++
title = "2. Install Docker"
date = 2019-09-18T10:46:30-04:00
weight = 45
tags = ["tutorial", "install", "AWS", "batch", "Docker", "ECR"]
+++

In this step, you will install Docker.  This is required for the next step to build a container and push it to Amazon ECR. 

You will also step through the procedure below, but you can also find the instructions to install docker by following [this guide](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/docker-basics.html#install_docker) and ensure that the pre-requisites shown on [this page](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/docker-basics.html#use-ecr) are fulfilled. 

#### To install Docker
1. Connect to your EC2 instance or open Cloud9.
2. Install the most recent **Docker Engine package**.
```bash
sudo amazon-linux-extras install docker
```
{{% notice info %}}
Skip **step 3** if using *Cloud9*. Go directly to **step 4**.
{{% /notice %}}

3. Add the *ssm-user* to the docker group so you can execute Docker commands without using sudo.
```bash
sudo usermod -a -G docker ssm-user
```
4. Start the **Docker service**.
```bash
sudo service docker start
```

{{% notice info %}}
Skip **step 5** if using *Cloud9*. Go directly to **step 6**.
{{% /notice %}}

5. Choose **Terminate** and **Connect** to pick up the new docker group permissions. Your new session will have the appropriate docker group permissions. 

6. Verify that the you can run Docker commands without sudo. 
```bash
docker info
```

Now you have successfully installed Docker. 

#### Next Steps
Continue to the next section to build and push the container.
