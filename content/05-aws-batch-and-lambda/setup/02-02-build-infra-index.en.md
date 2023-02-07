+++
title = "2. Provision Lambda, Batch and S3 buckets, etc.."
weight = 22
+++

In this section, you will deploy AWS Lambda, AWS Batch and Amazon S3 buckets with [AWS CloudFormation](https://aws.amazon.com/cloudformation/) templates, which are used to provision infrastructure as code, so the system can be managed and scaled to multi-region easily.

You will start to build the infrastructure with the shell schript "buildArch.sh" after downloading the YAML files for deployment with CloudFormation:
```bash
# download YAML files
mkdir -p fsi-demo/CloudFormation
cd fsi-demo
curl -o CloudFormation/fsi-demo-s3.yaml https://raw.githubusercontent.com/aws-samples/aws-hpc-tutorials/batch/static/scripts/batch-lambda/CloudFormation/fsi-demo-s3.yaml
curl -o CloudFormation/fsi-demo-batch.yaml https://raw.githubusercontent.com/aws-samples/aws-hpc-tutorials/batch/static/scripts/batch-lambda/CloudFormation/fsi-demo-batch.yaml
# build infrastructures
curl -o buildArch.sh https://raw.githubusercontent.com/aws-samples/aws-hpc-tutorials/batch/static/scripts/batch-lambda/buildArch.sh
./buildArch.sh
```
This will take several minutes. You can go through the script to see what it will do. The script starts with collecting some necessary information, such as AWS account ID, VPC ID, subnet IDs and security groups. The default VPC and security groups are choose here for simplicity of the experiments. You are recommended to create your own VPC, subnets and security groups to meet the security, scalability and compliance requirements. A file to save the collected information will be created in the home directory: ```~/envVars-$AWS_REGION```. You can just load the environment variables with the generated file for later tests.

Using collected information with the template file ```CloudFormation/fsi-demo-batch.yaml```, the script will deploy AWS Batch, including creating a compute environment, a job queue, a job definition and related IAM roles. Batch can support multiple clients and very large-scale workloads with additional Batch queues and compute environments.

Then the script will deploy the remaining infrastructures with ```CloudFormation/fsi-demo-s3.yaml```, such as input and output S3 buckets, lambda function and its S3 trigger, EventBridge rule for Batch jobs triggered from S3 events etc..

```
$ cat buildArch.sh 
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
    FSIBatchJobDefinitionArn=$project
```

After the deployment is done you can check with AWS Management Console for [CloudFormation](https://console.aws.amazon.com/cloudformation/) if the deployment has been done successfully and find out detail errors under the "Events" tab of each stack if there is an issue.
![CloudFormation](/images/batch-lambda/CloudFormation.png)
