+++
title = "- Build an IAM Policy with Cloudformation"
date = 2019-09-18T10:46:30-04:00
weight = 57
tags = ["tutorial", "IAM", "ParallelCluster", "Serverless"]
+++

Now we will create our policy. Let's start by downloading it. This step is not required but allows us to look at what new rights are being granted to our cluster.

1. Download the CloudFormation template containing the custom policy from the bucket `s3://aws-hpc-workshops` using the following command
    ```bash
    aws s3 cp s3://aws-hpc-workshops/serverless-template.yaml .
    ```
    Below are the contents of the **serverless-template.yaml** document for your information. This policy when attached to your cluster will allow the cluster instances to connect to the SSM endpoints so they can run the commands that are sent to them. This will also allow your instances to access the bucket you just created.


    {{%expand "See the content of serverless-template.yaml (click to expand)" %}}
    AWSTemplateFormatVersion: 2010-09-09
    Description: This template deploys the ParallelCluster additional policies required to use SSM.
    Parameters:
      S3Bucket:
        Description: Choose an existing S3 bucket used to store the input/output data from jobs and save the    output of SSM execution commands.
        Type: String
    Resources:
      pclusterSSM:
        Type: 'AWS::IAM::ManagedPolicy'
        Properties:
          ManagedPolicyName: pclusterSSM
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
      S3Bucket:
        Description: S3 Bucket name
        Value: !Sub ${S3Bucket}
    {{% /expand%}}

2. Deploy the cloudformation template and create the policy

    **Note**: The policy enables access to the S3 bucket created to store the job data and SSM commands. This is provided as ParameterValue below. Make sure to provide the correct S3 bucket name

    ```bash
    aws cloudformation create-stack --stack-name pc-serverless-policy --parameters ParameterKey=S3Bucket,ParameterValue=serverless-${BUCKET_POSTFIX} --template-body file://serverless-template.yaml --capabilities CAPABILITY_NAMED_IAM
    ```
{{% notice info %}}
The command above creates a Cloudformationstack as based on the template`serverless-template.yaml`. The policy name is specified in the template file. The `--stack-name` argument takes a unique name that will be associated with the stack on your account. The `--parameters` option specify the input parameters for the stack (here we pass `S3Bucket` as the key and name of the S3 Bucket as the Value). Furthermore, since we are creating IAM resources we must explicitly acknowledge that our stack template contains `--capabilities`. You could use the *AWS Console* to create this stack too.
{{% /notice %}}

3. Once the AWS CloudFormation stack creation completes, you can confirm the IAM Policy is created by running the command below in your Cloud9 Terminal to query the policy `pclusterSSM` you just created

   ```bash
   aws iam list-policies --query 'Policies[?PolicyName==`pclusterSSM`]'
   ```

   You should see a similar image as this one:
![Lambda Basic Settings](/images/serverless/iam-policy-result.png)

In the next section, we will modify our AWS ParallelCluster configuration and update the cluster to apply our newly created policy.


{{% notice tip %}}
You don't actually need to download the Cloudformation template to your Cloud9 instance. Indeed, it is possible to run Cloudformation templates that are already stored on S3. For that matter you could replace the `--template-file file://serverless-template.yaml` by the argument `--template-url https://aws-hpc-workshops.s3.amazonaws.com/serverless-template.yaml` and it will work as well.
{{% /notice %}}
