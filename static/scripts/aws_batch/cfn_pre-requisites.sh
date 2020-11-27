#!/bin/bash

STACK_NAME='PrepAVWorkshop2'

# create the stack
echo "1/3 - Create Stack $STACK_NAME"
aws cloudformation create-stack --stack-name $STACK_NAME --template-body file://s3policy.yaml --capabilities "CAPABILITY_IAM"

echo "2/3 - Stack $STACK_NAME being created"
# wait for the stack to be completed
aws cloudformation wait stack-create-complete --stack-name $STACK_NAME

echo "3/3 - Stack $STACK_NAME created"
# once done get the role
instanceRoleId=$(aws cloudformation describe-stacks --stack-name $STACK_NAME --output text --query 'Stacks[0].Outputs[?OutputKey == `S3RoleARN`].OutputValue')
ecsRoleId=$(aws cloudformation describe-stacks --stack-name $STACK_NAME --output text --query 'Stacks[0].Outputs[?OutputKey == `ECSTaskPolicytoS3`].OutputValue')
ecsJobExecutionRoleId=$(aws cloudformation describe-stacks --stack-name $STACK_NAME --output text --query 'Stacks[0].Outputs[?OutputKey == `ECSJobExecutionRole`].OutputValue')
outputBucket=$(aws cloudformation describe-stacks --stack-name $STACK_NAME --output text --query 'Stacks[0].Outputs[?OutputKey == `OutputBucket`].OutputValue')

echo "Use the following EC2 Role ID for Packer: $instanceRoleId"
echo "Use the following ECS Task Role ID for AWS Batch: $ecsRoleId"
echo "Use the following ECS Job Execution Role ID for AWS Batch: $ecsJobExecutionRoleId"
echo "Use the this S3 Bucket for your AWS Batch jobs to write Data: $outputBucket"

export ROLE_ID=${instanceRoleId}
