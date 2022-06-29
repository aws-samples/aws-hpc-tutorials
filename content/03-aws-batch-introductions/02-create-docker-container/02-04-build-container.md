+++
title = "3. Build & push container"
date = 2019-09-18T10:46:30-04:00
weight = 46
tags = ["tutorial", "install", "AWS", "batch", "Docker", "ECR"]
+++

Now that your instance is ready and docker is installed it is time to build the container and upload it to Amazon ECR:

#### To build and push your Docker container
1. Connect to your EC2 instance via Session Manager or open Cloud9.
2. Write the content below. It will create the Dockerfile required.
```bash
cat << EOF > ~/Dockerfile 
FROM public.ecr.aws/amazonlinux/amazonlinux:2 
RUN amazon-linux-extras install epel -y && yum install stress-ng -y 
CMD /usr/bin/stress-ng 
EOF
cd ~
```

5. Run the script below to build and push the container image to the Amazon ECR repository you created when deploying the Batch CloudFormation stack. 
	- *If running on your own workstation, ensure that the account ID and region are properly set for the environment variables `AWS_ACCOUNT_ID` and `AWS_REGION`. If further guidance is needed, follow this [guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-quickstart.html).*


```bash
!/bin/bash

sudo yum install jq

# set environment variables
AWS_ACCOUNT_ID=`aws sts get-caller-identity | jq -r '.Account'` # or replace by your account ID
export AWS_REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/region) # or replace by your region
ECR_URL=`aws cloudformation describe-stacks --stack-name LargeScaleBatch --query "Stacks[0].Outputs[?OutputKey=='ECRRepositoryUrl'].OutputValue" --output text --region ${AWS_REGI\
ON}`
ECR_BASE_DIRECTORY=$(echo "$ECR_URL" | cut -d "/" -f1)

# Authenticate with ECR
aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_BASE_DIRECTORY}

# Build the image
docker build -f ~/Dockerfile -t ${ECR_URL}:latest .

# Push your image to your ECR repository
docker push ${ECR_URL}:latest
```
6. Verify that the *stress-ng* container has been added to **Amazon ECR**. ([link](https://console.aws.amazon.com/ecr/)) ![EC2 instance create](/images/aws-batch/deep-dive/Amazon_ECR.png)


By this point in the workshop, you should have

1. Deployed your network environment
2. Deployed your AWS Batch environment
3. Created the container image that will be used to run your batch jobs.

#### Next Steps
Now you will now run a test workload in AWS Batch to evaluate its behavior.
