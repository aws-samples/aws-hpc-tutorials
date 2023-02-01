+++
title = "1. Create application container image"
weight = 21
+++

You will download the Bash script "updateImage.sh" to build a container image and upload it to Amazon Elastic Container (Amazon ECR). The script will build the image first, then create an Amazon ECR repository for the first time and store the container image to it. Then update the container images with the same script afterwards. The same container image is shared by both AWS Batch and Lambda. For AWS Lambda, we need an additional step to deploy the container image for each update. 

```bash
curl -o updateImage.sh https://raw.githubusercontent.com/aws-samples/aws-hpc-tutorials/batch/static/scripts/batch-lambda/updateImage.sh
./updateImage.sh
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

After the script execution is done, you can check if the repositories are created as expected. In additional to use command to check, you can also check the result with [AWS Management Console](https://console.aws.amazon.com/ecr/repositories) by choosing the same AWS region above.
```bash
aws ecr describe-repositories --region ${AWS_REGION} --output text --query 'repositories[*].repositoryName'
```
The output should include the following ECR repositories:

```
fsi-demo
```
