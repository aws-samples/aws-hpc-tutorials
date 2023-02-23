#!/bin/bash

project=fsi-demo

##### Gather necessary information and save in a file for later use #####
envFileName=~/envVars-$AWS_REGION

# Get the AWS account and region information dynamically, or specify region with the environment variable.
echo "Deploying to ${AWS_REGION:=$(curl --silent http://169.254.169.254/latest/meta-data/placement/region)} region"
echo "export AWS_REGION=${AWS_REGION}" > $envFileName

AWS_ACCOUNT=$(aws sts get-caller-identity --query "Account" --output text)
echo "export AWS_ACCOUNT=${AWS_ACCOUNT}" >> $envFileName

VPC_ID=`aws ec2 describe-vpcs --output text --query 'Vpcs[*].VpcId' --filters Name=isDefault,Values=true --region ${AWS_REGION}`
echo "export VPC_ID=${VPC_ID}" >> $envFileName

SUBNET_IDS=`aws ec2 describe-subnets --query "Subnets[*].SubnetId" --filters Name=vpc-id,Values=${VPC_ID} --region ${AWS_REGION} --output text | sed 's/\s\+/,/g'`
echo "export SUBNET_IDS=${SUBNET_IDS}" >> $envFileName

SecurityGroup_IDS=`aws ec2 describe-security-groups  --query 'SecurityGroups[*].GroupId' \
                 --filters Name=vpc-id,Values=${VPC_ID}  Name=group-name,Values=default --region ${AWS_REGION} --output text`
echo "export SecurityGroup_IDS=${SecurityGroup_IDS}" >> $envFileName

RouteTable_IDS=`aws ec2 describe-route-tables --query 'RouteTables[*].RouteTableId' \
                 --filters Name=vpc-id,Values=${VPC_ID} --region ${AWS_REGION} --output text | sed 's/\s\+/,/g'`
echo "export RouteTable_IDS=${RouteTable_IDS}" >> $envFileName

##### step 1: AWS Batch provision #####
aws cloudformation deploy --stack-name fsi-demo-batch --template-file CloudFormation/fsi-demo-batch.yaml --capabilities CAPABILITY_IAM \
--region ${AWS_REGION} --parameter-overrides VpcId=${VPC_ID} SubnetIds="${SUBNET_IDS}" SGIds="${SecurityGroup_IDS}"

###### step 2: Create S3 buckets for input and output files ######
echo "Input S3 bucket name: ${INPUT_BUCKET:=$project-${AWS_REGION}-${AWS_ACCOUNT}}"
echo "export INPUT_BUCKET=$INPUT_BUCKET" >> $envFileName

echo "Result S3 bucket name: ${RESULT_BUCKET=${INPUT_BUCKET}-result}"
echo "export RESULT_BUCKET=$RESULT_BUCKET" >> $envFileName

aws cloudformation deploy --stack fsi-demo --template-file CloudFormation/fsi-demo-s3.yaml --capabilities "CAPABILITY_IAM" \
    --region ${AWS_REGION} --parameter-overrides INPUTBUCKET=$INPUT_BUCKET FSIBatchJobQueueArn=arn:aws:batch:${AWS_REGION}:${AWS_ACCOUNT}:job-queue/$project \
    FSIBatchJobDefinitionArn=$project SubnetIds="${SUBNET_IDS}" SGIds="${SecurityGroup_IDS}" VPCId="${VPC_ID}" RTIds="${RouteTable_IDS}"
