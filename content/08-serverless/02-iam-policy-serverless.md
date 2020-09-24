+++
title = "a. Create IAM policy for SSM endpoints"
date = 2019-09-18T10:46:30-04:00
weight = 50
tags = ["tutorial", "IAM", "ParallelCluster", "Serverless"]
+++

{{% notice info %}}See [AWS Identity and Access Management Roles in AWS ParallelCluster](https://docs.aws.amazon.com/parallelcluster/latest/ug/iam.html) for details on the default AWS ParallelCluster policy.
{{% /notice %}}

In order to allow ParallelCluster instances to call Lambda and SSM endpoints, it is necessary to configure a custom IAM Policy and attach to the cluster

1. Open a terminal in your Cloud9 instance

2. Create an Amazon S3 bucket to store the input/output data from jobs and save the output of SSM execution commands
   ```bash
   #generate a unique postfix
   export BUCKET_POSTFIX=$(uuidgen --random | cut -d'-' -f1)
   echo "Your bucket name will be serverless-${BUCKET_POSTFIX}"
   aws s3 mb s3://serverless-${BUCKET_POSTFIX}
   ```
3. Create a custom IAM policy using AWS Cloudformation

   - Download the cloudformation template for the custom policy from the AWS HPC Workshops S3 bucket
     Note: The name of the policy document is policy.yaml
     ```bash
     aws s3 cp s3://aws-hpc-workshops/policy.yaml .
     ```
   - Deploy the cloudformation template and create the policy

     Note: The policy enables access to the S3 bucket created to store the job data and SSM commands. This is provided as ParameterValue below. Make sure to provide the correct S3 bucket name

     ```bash
     aws cloudformation create-stack --stack-name parallelcluster-serverless-policy --parameters ParameterKey=S3Bucket,ParameterValue=serverless-${BUCKET_POSTFIX} --template-body file://policy.yaml --capabilities CAPABILITY_NAMED_IAM
     ```     
   
4. Once the cloudformation stack creation completes, you can confirm the IAM Policy is created by navigating to the Identity and Access Management (IAM) on your console
   - Click on Services -> IAM
   - Click on Policies under Access management
   - Search for *pclusterSSM* which is the name of the Policy as defined in the policy.yaml document

     ![IAM Policy](/images/serverless/iam-policy.png)


Next, we will update the policy in AWS ParallelCluster and re-deploy the cluster
