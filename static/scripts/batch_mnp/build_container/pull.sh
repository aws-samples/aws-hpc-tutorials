#!/bin/bash
source ./config.properties

echo "Logging into ECR"
aws ecr get-login-password --region ${region} | docker login --username AWS \
    --password-stdin ${registry}

echo "Pulling Container from ECR"
docker pull  ${registry}${image_name}${image_tag}

echo "Done..."