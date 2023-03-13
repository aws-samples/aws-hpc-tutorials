#!/bin/bash
source ./config.properties

echo "Logging into ECR"
aws ecr get-login-password --region ${region} | docker login --username AWS \
    --password-stdin ${registry}

#echo "Tagged benchmark_torchenv to ECR"
#docker tag sshd_instances:v1 561120826261.dkr.ecr.us-east-1.amazonaws.com/sshd_instances:v1

echo "Pushing to ECR"
docker push ${registry}${image_name}${image_tag}

echo "Done..."