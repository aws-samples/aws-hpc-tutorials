+++
title = "1. Create application container image"
weight = 21
+++

You will download the Bash script "updateImage.sh" to build a container image and upload it to Amazon Elastic Container (Amazon ECR). There are four dependent files for this step:
1. Dockerfile : provide image build instructions
2. bootstrap : the entrypoint for both AWS Batch and Lambda containers
3. function.sh : workload distribution and execution to run jobs in parallel
4. EquityOption.cpp : I/O interface for building QuantLib binary to read and write information from multiple equities

The script will build the image first, then store the container image with Amazon ECR. It creates an repository for the first time and update the container images afterwards. The same container image is shared by both AWS Batch and Lambda. For AWS Lambda, we need an additional step to deploy the container image for each update. 

```bash
# Create a new working directory
mkdir -p ~/fsi-demo
cd ~/fsi-demo
# Download files
curl -o updateImage.sh https://raw.githubusercontent.com/aws-samples/aws-hpc-tutorials/batch/static/scripts/batch-lambda/updateImage.sh
curl -o Dockerfile https://raw.githubusercontent.com/aws-samples/aws-hpc-tutorials/batch/static/scripts/batch-lambda/Dockerfile
curl -o bootstrap https://raw.githubusercontent.com/aws-samples/aws-hpc-tutorials/batch/static/scripts/batch-lambda/bootstrap
curl -o function.sh https://raw.githubusercontent.com/aws-samples/aws-hpc-tutorials/batch/static/scripts/batch-lambda/function.sh
curl -o EquityOption.cpp https://raw.githubusercontent.com/aws-samples/aws-hpc-tutorials/batch/static/scripts/batch-lambda/EquityOption.cpp
# Set up AWS region
export AWS_REGION=$(curl --silent http://169.254.169.254/latest/meta-data/placement/region)
# Execute the script
bash ./updateImage.sh
```

While waiting, you can take a look at script as described above.

```
$ cat updateImage.sh 
#!/bin/bash

project=fsi-demo

# Get the AWS account and region information dynamically
echo "Updating images in ${AWS_REGION:=$(curl --silent http://169.254.169.254/latest/meta-data/placement/region)} region"
export AWS_REGION
export AWS_ACCOUNT=$(curl -s 169.254.169.254/latest/meta-data/identity-credentials/ec2/info | jq -r '.AccountId')

# build docker image
DOCKER_BUILDKIT=1  docker build -t $project -f Dockerfile ./

# Create an ECR repository if not exist
aws ecr describe-repositories --repository-names $project --region ${AWS_REGION} --no-cli-pager|| \
aws ecr create-repository --repository-name $project --region ${AWS_REGION} --no-cli-pager --image-scanning-configuration scanOnPush=true

# Tag the new image
docker tag $project:latest ${AWS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com/$project:latest

# Push the new image to the ECR repository
aws ecr get-login-password | docker login --username AWS --password-stdin ${AWS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com
docker push ${AWS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com/$project:latest

# Need to redeploy with the new image for lambda
# Note: the function will not be updated before it is created with cloud formation
aws lambda get-function --function-name $project --region ${AWS_REGION} --no-cli-pager > /dev/null 2>&1 && \
aws lambda update-function-code --region ${AWS_REGION} --function-name $project \
    --image-uri ${AWS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com/$project:latest --no-cli-pager
```

After the script execution is done, you can check if the repositories are created as expected. In addition to use command to check, you can also check the result with [AWS Management Console](https://console.aws.amazon.com/ecr/repositories) by choosing the same AWS region above.
```bash
aws ecr describe-repositories --region ${AWS_REGION} --output text --query 'repositories[*].repositoryName'
```
The output should include the following ECR repositories:

```
fsi-demo
```
