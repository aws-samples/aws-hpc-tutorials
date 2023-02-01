+++
title = "1. Create application container image"
weight = 21
+++

The following Bash script "updateImage.sh" should exist at the top level of the "fsi-demo" directory after the repository is cloned in the previous step. The script will create Amazon ECR repositories for the first time and save the container images after build. Then update the container images with the same script afterwards. The script can be run either on a Cloud9 instance, or in [AWS CodeBuild](https://aws.amazon.com/codebuild/) environment for CI/CD implementation, which is beyond the scope of this workshop.

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

Now you can run the script to create repositories in Amazon ECR to store container images for both AWS Lambda and Batch. AWS_REGION can be set optionally to specify where the infrastructure to be provisioned. If the AWS_REGION not set, it will deploy to the same region as Cloud9 instance automatically.
```bash
./updateImage.sh
```

Then you can check if the repositories are created as expected. In additional to use command to check, you can also check the result with [AWS Management Console](https://console.aws.amazon.com/ecr/repositories) by choosing the same AWS region above.
```bash
aws ecr describe-repositories --region ${AWS_REGION} --output text --query 'repositories[*].repositoryName'
```
The output should include the following ECR repositories:

```
fsi-demo-batch  fsi-demo-lambda
```
