+++
title = "b. Create IAM policy for SSM endpoints"
date = 2019-09-18T10:46:30-04:00
weight = 50
tags = ["tutorial", "IAM", "ParallelCluster", "Serverless"]
+++

IAM controls who or what can conduct actions on resources. For example, an instance can be allowed to access the APIs to create new instances. In the present case, we will enable the nodes of your cluster to access the AWS Systems Manager (SSM) endpoints so commands triggered by our Lambda function can be executed on them using SSM.

In this section we will :

- Create an Amazon S3 bucket to store store our Slurm `sbatch` scripts and the SSM commands logs (for auditing).
- Define an new [IAM policy](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html) that we will apply on our cluster during the next step. This policy enables our instances to register with SSM and access our S3 bucket.

<!-- ParallelCluster you can consult [this documentation](https://docs.aws.amazon.com/parallelcluster/latest/ug/iam.html). -->


#### Create the S3 Bucket

Let's start by creating a new bucket.

1. As for the previous lab, in the AWS Management Console search bar, type and select **Cloud9**.
2. Choose **open IDE** for the Cloud9 instance set up previously. It may take a few moments for the IDE to open. AWS Cloud9 stops and restarts the instance so that you do not pay compute charges when no longer using the Cloud9 IDE.
3. If you have a terminal readily available on your Cloud9 IDE, use it. Otherwise, click on the menu **Window** in Cloud9's top bar then select **New Terminal**
4. Create an Amazon S3 bucket to store the input/output data from jobs and save the [AWS Systems Manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/what-is-systems-manager.html) (SSM) execution commands.

    ```bash
    # generate a unique postfix
    export BUCKET_POSTFIX=$(uuidgen --random | cut -d'-' -f1)
    echo "Your bucket name will be serverless-${BUCKET_POSTFIX}"
    aws s3 mb s3://serverless-${BUCKET_POSTFIX}
    ```

#### Create the IAM Policy through AWS Cloudformation

Now we will create our policy. We will download it for didactic purposes but it is not required.

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
    {{% /expand%}}

2. Deploy the cloudformation template and create the policy

    **Note**: The policy enables access to the S3 bucket created to store the job data and SSM commands. This is provided as ParameterValue below. Make sure to provide the correct S3 bucket name

    ```bash
    aws cloudformation create-stack --stack-name pc-serverless-policy --parameters ParameterKey=S3Bucket,ParameterValue=serverless-${BUCKET_POSTFIX} --template-body file://serverless-template.yaml --capabilities CAPABILITY_NAMED_IAM
    ```

    This command creates a stack as specified in the `serverless-template.yaml` template body. The policy name is specified in the template file. The *stack-name* is the unique name that is associated with the stack. The *parameters* option is a list of Parameter structures that specify input parameters for the stack (here we pass `S3Bucket` as the key and name of the S3 Bucket as the Value). When creating IAM resources you must explicitly acknowledge that your stack template contains *capabilities* in order for AWS CloudFormation to create the stack.


3. Once the AWS CloudFormation stack creation completes, you can confirm the IAM Policy is created by using the AWS CLI as shown below

   **Note**: You are querying the name of the Policy (**pclusterSSM**) in the below command


   ```bash
   aws iam list-policies --query 'Policies[?PolicyName==`pclusterSSM`]'
   ```


Next, we will update the policy in AWS ParallelCluster and re-deploy the cluster


{{% notice tip %}}
You don't actually need to download the Cloudformation template to your Cloud9 instance. Indeed, it is possible to run Cloudformation templates that are already stored on S3. For that matter you could replace the `--template file file://serverless-template.yaml` by the argument `--template-url https://aws-hpc-workshops.s3.amazonaws.com/serverless-template.yaml` and it will work as well.
{{% /notice %}}
