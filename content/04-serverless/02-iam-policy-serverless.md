+++
title = "a. Create IAM policy for SSM endpoints"
date = 2019-09-18T10:46:30-04:00
weight = 50
tags = ["tutorial", "IAM", "ParallelCluster", "Serverless"]
+++

{{% notice info %}}See [AWS Identity and Access Management Roles in AWS ParallelCluster](https://docs.aws.amazon.com/parallelcluster/latest/ug/iam.html) for details on the default AWS ParallelCluster policy.
{{% /notice %}}

In order to allow ParallelCluster instances to call Lambda and SSM endpoints, it is necessary to configure a custom Identity and Access Management (IAM) Policy and attach to the cluster

1. Open a terminal in your AWS Cloud9 instance

2. Create an Amazon S3 bucket to store the input/output data from jobs and save the output of [AWS Systems Manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/what-is-systems-manager.html) (SSM)  execution commands

	{{%expand "What is AWS Systems Manager ?" %}}
	AWS Systems Manager is an AWS service that you can use to view and control your infrastructure on AWS. Using the Systems Manager console, you can view operational data from multiple AWS services and automate operational tasks across your AWS resources
	{{% /expand%}}

	```bash
	# generate a unique postfix
     	export BUCKET_POSTFIX=$(uuidgen --random | cut -d'-' -f1)
     	echo "Your bucket name will be serverless-${BUCKET_POSTFIX}"
     	aws s3 mb s3://serverless-${BUCKET_POSTFIX}

3. Create a custom IAM policy using AWS Cloudformation

   - Download the CloudFormation template for the custom policy from the AWS HPC Workshops S3 bucket

     **Note**: The name of the policy document is **policy.yaml**

     ```bash
     aws s3 cp s3://aws-hpc-workshops/policy.yaml
     ```

   - Below are the contents of the **policy.yaml** document for your information. This policy when attached to your cluster will allow the cluster instances to call AWS Lambda and AWS SSM endpoints

	    ```bash
	    AWSTemplateFormatVersion: 2010-09-09
	    Description: This template deploys the ParallelCluster additional policies required to use SSM.
	    Parameters:
	      S3Bucket:
		Description: Choose an existing S3 bucket used to store the input/output data from jobs and save the output of SSM execution commands.
		Default: pcluster-data
		Type: String
	    Resources:
	      pclusterSSM:
		Type: 'AWS::IAM::ManagedPolicy'
		Properties:
		   ManagedPolicyName: pclusterSSM2
		   Path: /
		   PolicyDocument:
		     Version: 2012-10-17
		     Statement:
		       - Effect: Allow
			 Action:
				- 'ssm:DescribeAssociation'
				- 'ssm:GetDeployablePatchSnapshotForInstance'
				- 'ssm:GetDocument'
				- 'ssm:DescribeDocument'
				- 'ssm:GetManifest'
				- 'ssm:GetParameter'
				- 'ssm:GetParameters'
				- 'ssm:ListAssociations'
				- 'ssm:ListInstanceAssociations'
				- 'ssm:PutInventory'
				- 'ssm:PutComplianceItems'
				- 'ssm:PutConfigurePackageResult'
				- 'ssm:UpdateAssociationStatus'
				- 'ssm:UpdateInstanceAssociationStatus'
				- 'ssm:UpdateInstanceInformation'
				- 'ssmmessages:CreateControlChannel'
				- 'ssmmessages:CreateDataChannel'
				- 'ssmmessages:OpenControlChannel'
				- 'ssmmessages:OpenDataChannel'
				- 'ec2messages:AcknowledgeMessage'
				- 'ec2messages:DeleteMessage'
				- 'ec2messages:FailMessage'
				- 'ec2messages:GetEndpoint'
				- 'ec2messages:GetMessages'
				- 'ec2messages:SendReply'

		 Resource: '*'
		       - Effect: Allow
			 Action:
			   - 's3:*'
			 Resource: !Sub 'arn:aws:s3:::${S3Bucket}/*'
	     Outputs:
	       PclusterPolicy:
		Description: PclusterPolicy
		Value: !Sub ${pclusterSSM}

   - Deploy the cloudformation template and create the policy

     **Note**: The policy enables access to the S3 bucket created to store the job data and SSM commands. This is provided as ParameterValue below. Make sure to provide the correct S3 bucket name

     ```bash
     aws cloudformation create-stack --stack-name pc-serverless-policy --parameters ParameterKey=S3Bucket,ParameterValue=serverless-${BUCKET_POSTFIX} --template-body file://policy.yaml --capabilities CAPABILITY_NAMED_IAM
     ```
	    {{%expand "What does this command do ?" %}}
	    This command creates a stack as specified in the "policy.yaml" template body. The policy name is specified in the template file. The "stack-name" is the unique name that is associated with the stack. The "parameters" option is a list of Parameter structures that specify input parameters for the stack (here we pass the S3Bucket as the key and name of the S3 Bucket as the Value). When creating certain Identity and Access Management (IAM) resources you must explicitly acknowledge that your stack template contains "capabilities" in order for AWS CloudFormation to create the stack.

	    {{% /expand%}}

4. Once the AWS CloudFormation stack creation completes, you can confirm the IAM Policy is created by using the AWS CLI as shown below

   **Note**: You are querying the name of the Policy (**pclusterSSM**) in the below command


   ```bash
   aws iam list-policies --query 'Policies[?PolicyName==`pclusterSSM`]'
   ```


Next, we will update the policy in AWS ParallelCluster and re-deploy the cluster
