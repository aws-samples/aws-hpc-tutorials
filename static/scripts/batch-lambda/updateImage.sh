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
