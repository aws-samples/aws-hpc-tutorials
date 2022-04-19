+++
title = "d. Build and upload your Container"
date = 2019-09-18T10:46:30-04:00
weight = 40
tags = ["tutorial", "install", "AWS", "batch", "Docker", "ECR"]
+++

#### Building and uploading your container
In the previous steps, we have used AWS Cloudformation Templates to deploy both our VPC and Batch environments for us to run our tests. In this section, you will build the container image to be used in the test and upload it to Amazon ECR.

[stress-ng](https://kernel.ubuntu.com/~cking/stress-ng/) is used to simulate the behavior of a computational process for a duration of 10 minutes. You will create the image and upload it to Amazon ECR using Docker using an Amazon EC2 instance with Docker. A *t2.micro* instance is sufficient for this. 

##### Deploy an Amazon EC2 instance
1. **Open** the Amazon EC2 console ([link](https://console.aws.amazon.com/ec2/v2/)) to find your Amazon EC2 instances.
![EC2 instance create](/images/aws-batch/deep-dive/Instances___EC2_Management_Console.png)
2. **Click** on *Launch Instances* in the upper right hand corner. ![EC2 instance create](/images/aws-batch/deep-dive/Instances___EC2_Management_Console-2.png)
3. **Type** the name of your instance. Here you can see the instance name is *DockerBuilder*. Please use whatever you see fit. ![EC2 instance create](/images/aws-batch/deep-dive/Launch_an_instance___EC2_Management_Console.png)
4. **Keep** the Amazon Machine Image and Instance type at the default values.  These should be free eir eligable.  ![EC2 instance create](/images/aws-batch/deep-dive/Cursor_and_Launch_an_instance___EC2_Management_Console.png)
5. **Create** a new key pair to be able to connect to your new instance.![EC2 instance create](/images/aws-batch/deep-dive/EC2_KP1.png) 
6. **Type** the name of your key pair. Here you can see the instance name is *dockerKP*. Please use whatever you see fit. ![EC2 instance create](/images/aws-batch/deep-dive/EC2_KP2.png) 
7. **Click** on *Create key pair.* ![EC2 instance create](/images/aws-batch/deep-dive/EC2_KP3.png) 
8. **Note** that the key pair has been downloaded to your computer. ![EC2 instance create](/images/aws-batch/deep-dive/EC2_KP4.png) 
9. **Click** on *Edit* in Network Settings to make sure the EC2 instance is in the correct VPC. ![EC2 instance create](/images/aws-batch/deep-dive/EC2_Management_Console.png) 
10. **Select** the VPC you created in the first template in the VPC box.![EC2 instance create](/images/aws-batch/deep-dive/EC2_Management_Console-2.png) 
11. **Select** the public subnet you created in the first template in the subnet box.![EC2 instance create](/images/aws-batch/deep-dive/EC2_Management_Console-3.png) 
12. **Choose** *Create security group* under the firewall option.  ![EC2 instance create](/images/aws-batch/deep-dive/EC2_Management_Console-4.png) 
13. **Leave** all other sections in Network settings with the *default* values.
14. **Review** the *Summary* box before you launch.![EC2 instance create](/images/aws-batch/deep-dive/EC2_Management_Console-5.png) 
15. **Click** *Launch instance* to launch your instance![EC2 instance create](/images/aws-batch/deep-dive/EC2_Management_Console-6.png) 
16. **Note** the successful launch of the instance and click *View all instances* ![EC2 instance create](/images/aws-batch/deep-dive/EC2_Management_Console-7.png) 

##### Add instance role
1. **Check** that the instance you just created is running. **Check** the checkbox next to that instace. **Drop** the *Action* menu. ![EC2 instance create](/images/aws-batch/deep-dive/EC2_Management_Console-8.png)
2. **Select** *Security* from the menu options. ![EC2 instance create](/images/aws-batch/deep-dive/Instances___EC2_Management_Console-3.png)
3. **Select** *Modify IAM role* under the security options. Your instance needs to have the policy `AmazonEC2ContainerRegistryPowerUser` attached to its [IAM role](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-roles-for-amazon-ec2.html)![EC2 instance create](/images/aws-batch/deep-dive/Instances___EC2_Management_Console-4.png)
4. **Click** *Create new IAM role*. This will send you to the IAM Roles page.  ![EC2 instance create](/images/aws-batch/deep-dive/Modify_IAM_role___EC2_Management_Console.png)
5. **Select** *Create role*. ![EC2 instance create](/images/aws-batch/deep-dive/IAM_Management_Console.png)
6. **Choose** the Trusted entity type to the AWS service and **choose** the common use cases to be *EC2*. **Click** *Next* on the bottom right hand corner.![EC2 instance create](/images/aws-batch/deep-dive/IAM_Management_Console-2.png)
7. **Type** `AmazonEC2ContainerRegistryPowerUser` into the search bar. **Hit** enter. ![EC2 instance create](/images/aws-batch/deep-dive/IAM_Management_Console-3.png)
8. **Check** the box next to `AmazonEC2ContainerRegistryPowerUser`. **Click** *Next*. ![EC2 instance create](/images/aws-batch/deep-dive/IAM_Management_Console-4.png)
9.  **Type** the name of your new role. Here you can see the Role name is *DockerBuilderRole*. Please use whatever you see fit.![EC2 instance create](/images/aws-batch/deep-dive/IAM_Management_Console-5.png)
10.  **Leave** all other sections with the *default* values. **Click** *Create role* on the bottom right hand side of the page.![EC2 instance create](/images/aws-batch/deep-dive/IAM_Management_Console-6.png)
11. **Open** the Amazon EC2 console again ([link](https://console.aws.amazon.com/ec2/v2/)) to find your Amazon EC2 instances now that you have created the role . ![EC2 instance create](/images/aws-batch/deep-dive/EC2_Management_Console-8.png)
2. **Select** *Security* from the menu options. ![EC2 instance create](/images/aws-batch/deep-dive/Instances___EC2_Management_Console-3.png)
3. **Select** *Modify IAM role* under the security options. Now we will add the policy we have just created to the instance. [EC2 instance create](/images/aws-batch/deep-dive/Instances___EC2_Management_Console-4.png)
4. **Select** the new IAM role from the drop down menu. **Click** *Save*.  ![EC2 instance create](/images/aws-batch/deep-dive/Modify_IAM_role___EC2_Management_Console-2.png)

##### Connect to your instance
1. **Check** that the instance you just created is running. **Check** the checkbox next to that instace. **Drop** the *Action* menu. ![EC2 instance create](/images/aws-batch/deep-dive/EC2_Management_Console-8.png)
2. **Select** *Connect* from the menu options. ![EC2 instance create](/images/aws-batch/deep-dive/EC2_Management_Console-9.png) 
3. **Connect** to your instance. There are multiple ways to connect to your instance.  **Select** your preffered way and follow the directions on the screen. Here, the workshop will use the terminal window to connect using the *key pair* we created in the above step. ![EC2 instance create](/images/aws-batch/deep-dive/Connect_to_instance___EC2_Management_Console.png)
![EC2 instance create](/images/aws-batch/deep-dive/terminal_1.png)

##### Install Docker on your Amazon EC2 instance
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

