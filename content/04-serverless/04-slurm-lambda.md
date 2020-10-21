+++
title = "c. Create Lambda Function for Slurm execution"
date = 2019-09-18T10:46:30-04:00
weight = 150
tags = ["tutorial", "serverless", "ParallelCluster", "Lambda", "Slurm"]
+++


AWS Lambda allows you to run your code without provisioning or managing servers. Lambda is used, in this solution, to execute the Slurm commands in the Head node. The Lambda function uses AWS Systems Manager (SSM) to execute the scheduler commands without logging into the head node. This further enhances the security of the cluster as you can avoid port exposure as well.  

In this section, we will create the the AWS Lambda function from the AWS Console

1. Open the AWS Management Console and go to Services -> Lambda.

2. Choose **Create a function** 

3. For **Function name**, enter **slurmAPI**

4. For **Runtime**, enter **Python 2.7**

5. Choose **Create function** to create it. 

![Lambda Create Function](/images/serverless/lambda-create-fn.png)

The Designer shows an overview of your function and its upstream and downstream resources. You can use it to configure triggers, layers, and destinations.

6. The code below should be pasted into the Function code section. The Lambda function uses AWS Systems Manager (SSM) to execute the scheduler commands, preventing any SSH access to the node.

```python
import boto3
import time
import json
import random
import string
import os


def lambda_handler(event, context):
    instance_id = event["queryStringParameters"]["instanceid"]
    selected_function = event["queryStringParameters"]["function"]
    if selected_function == 'list_jobs':
        command = 'squeue'
    elif selected_function == 'list_nodes':
        command = 'scontrol show nodes'
    elif selected_function == 'list_partitions':
        command = 'scontrol show partitions'
    elif selected_function == 'job_details':
        jobid = event["queryStringParameters"]["jobid"]
        command = 'scontrol show jobs %s' % jobid
    elif selected_function == 'submit_job':
        script_name = ''.join([
            random.choice(string.ascii_letters + string.digits)
            for n in xrange(10)
        ])
        jobscript_location = event["queryStringParameters"][
            "jobscript_location"]
        command = 'aws s3 cp s3://%s %s.sh; chmod +x %s.sh' % (
            jobscript_location, script_name, script_name)
        s3_tmp_out = execute_command(command, instance_id)
        submitopts = ''
        try:
            submitopts = event["headers"]["submitopts"]
        except Exception as e:
            submitopts = ''
        command = 'sbatch %s %s.sh' % (submitopts, script_name)
    body = execute_command(command, instance_id)
    return {
        'statusCode': 200,
        'body': body,
    }


def execute_command(command, instance_id):
    runtime_region = os.environ['AWS_REGION']
    bucket_name = os.environ['MY_S3_BUCKET']
    ssm_client = boto3.client('ssm', region_name=runtime_region)
    s3 = boto3.resource('s3')
    bucket = s3.Bucket(bucket_name)
    username = 'ec2-user'
    response = ssm_client.send_command(
        InstanceIds=["%s" % instance_id],
        DocumentName="AWS-RunShellScript",
        OutputS3BucketName=bucket_name,
        OutputS3KeyPrefix="ssm",
        Parameters={
            'commands': [
                'sudo su - %s -c "%s"' % (username, command),
            ]
        },
    )
    command_id = response['Command']['CommandId']
    time.sleep(1)
    output = ssm_client.get_command_invocation(
        CommandId=command_id,
        InstanceId=instance_id,
    )
    while output['Status'] != 'Success':
        time.sleep(1)
        output = ssm_client.get_command_invocation(CommandId=command_id,
                                                   InstanceId=instance_id)
        if (output['Status']
                == 'Failed') or (output['Status']
                                 == 'Cancelled') or (output['Status']
                                                     == 'TimedOut'):
            break
    body = ''
    files = list(
        bucket.objects.filter(
            Prefix='ssm/%s/%s/awsrunShellScript/0.awsrunShellScript' %
            (command_id, instance_id)))
    for obj in files:
        key = obj.key
        body += obj.get()['Body'].read()
    return body
```

7. Click **Deploy** in top right to save the function

8. In the **Environment variables** section, add the name of the S3 Bucket you created earlier. 

   Note: Do not modify the Key as it is used in the AWS Lambda function created above. Modify only the **Value** field with your S3 bucket name
![Lambda Env](/images/serverless/lambda-env.png)


9. In the **Basic settings** section, set 20 seconds as Timeout. Default is 3 seconds. 
![Lambda Basic Settings](/images/serverless/lambda-basic-set1.png)

10. In the **Execution role** section of **Basic settings**, choose **View the join-domain-function-role role on the IAM console**  as shown in the image below. 

**Note**: By default, Lambda will create an execution role with permissions to upload logs to [Amazon CloudWatch](https://aws.amazon.com/cloudwatch/) Logs. You can customize this default role later when adding triggers. In this case we will add an additional Policy to this role for the Lambda function to execute the scheduler (Slurm) commands using AWS Systems Manager (SSM).

![Lambda Basic Settings](/images/serverless/lambda-basic-set.png)

11. In the newly-opened IAM tab, choose **Attach policies** and then **Create policy**. This will open a new tab in your Browser. In this new tab, choose **Create policy** and then **JSON**

![Lambda IAM ](/images/serverless/lambda-iam1.png)

![Lambda IAM ](/images/serverless/lambda-iam2.png)

![Lambda IAM ](/images/serverless/lambda-iam3.png)


12. Paste the below policy, modify the **\<REGION\>** and **\<YOUR-S3-BUCKET-NAME\>** accordingly

    **Note**: This policy enables the AWS Lambda function to execute the scheduler command using AWS Systems Manager


```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ssm:SendCommand"
            ],
            "Resource": [
                "arn:aws:ec2:<REGION>:*:instance/*",
                "arn:aws:ssm:<REGION>::document/AWS-RunShellScript",
                "arn:aws:s3:::<YOUR-S3-BUCKET-NAME>/ssm"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "ssm:GetCommandInvocation"
            ],
            "Resource": [
                "arn:aws:ssm:<REGION>:*:*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": [
                "arn:aws:s3:::<YOUR-S3-BUCKET-NAME>",
                "arn:aws:s3:::<YOUR-S3-BUCKET-NAME>/*"
            ]
        }
    ]
}

```
{{% notice tip %}}
You can use the AWS CLI in your AWS Cloud9 console to get the REGION and S3 BUCKET information
{{% /notice %}}

To get the current AWS REGION:

```bash
   aws ec2 describe-availability-zones --output text --query 'AvailabilityZones[0].[RegionName]'
```

To list your S3 buckets:

```bash
  aws s3api list-buckets --query "Buckets[].Name"
```

13. In the next section, give a **Name** to the policy (e.g. lambda-slurm-exec) and select **Create policy**

![Lambda IAM ](/images/serverless/lambda-iam4.png)

14. In the previous tab, refresh the list, select the policy you created above and **Attach policy** as shown

![Lambda IAM ](/images/serverless/lambda-iam5.png)

![Lambda IAM ](/images/serverless/lambda-iam6.png)

15. **Save** changes to Lambda **Basic settings** 

![Lambda Basic Settings](/images/serverless/lambda-basic-set-save.png)

You have successfully created the AWS Lambda function for Slurm commands execution. Next, you will execute this AWS Lambda function with Amazon API Gateway


{{% notice note %}}
As an exercise you can trying creating the above AWS Lambda function using AWS Cloudformation
{{% /notice %}}
 
{{% notice tip %}}
To learn more about AWS Lambda and features see [here](https://docs.aws.amazon.com/lambda/latest/dg/welcome.html)
{{% /notice %}}

