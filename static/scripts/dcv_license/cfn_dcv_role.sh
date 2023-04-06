#!/bin/bash

STACK_NAME='DCVInstanceProfile'

# create the stack
echo "1/3 - Create Stack $STACK_NAME"
aws cloudformation create-stack --stack-name $STACK_NAME --template-body file://cfn_dcv_policy.yaml --capabilities "CAPABILITY_IAM"

echo "2/3 - Stack $STACK_NAME being created"
# wait for the stack to be completed
aws cloudformation wait stack-create-complete --stack-name $STACK_NAME

echo "3/3 - Stack $STACK_NAME created"
# once done get the role
instanceRoleId=$(aws cloudformation describe-stacks --stack-name $STACK_NAME --output text --query 'Stacks[0].Outputs[?OutputKey == `InstanceProfileARN`].OutputValue')

echo "Use the following instance profile on the EC2 instance: $instanceRoleId"
