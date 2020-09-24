+++
title = "c. Create Lambda Function for Slurm execution"
date = 2019-09-18T10:46:30-04:00
weight = 150
tags = ["tutorial", "serverless", "ParallelCluster", "Lambda", "Slurm"]
+++


AWS Lambda allows you to run your code without provisioning or managing servers. Lambda is used, in this solution, to execute the Slurm commands in the Head node. 

In this section, we will create the the AWS Lambda function from the AWS Console

1. Open the AWS Management Console and go to Services -> Lambda.

2. Choose **Create a function** 

3. For **Function name**, enter **slurmAPI**

4. For **Runtime**, enter **Python 2.7**

5. Choose **Create function** to create it. 

![Lambda Create Function](/images/serverless/lambda-create-fn.png)

The Designer shows an overview of your function and its upstream and downstream resources. You can use it to configure triggers, layers, and destinations.

6. The code below should be pasted into the Function code section. The Lambda function uses AWS Systems Manager to execute the scheduler commands, preventing any SSH access to the node. Please modify <REGION> appropriately, and update the S3 bucket name to the name you chose earlier.

```bash
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
      command='squeue'
    elif selected_function == 'list_nodes':
      command='scontrol show nodes'
    elif selected_function == 'list_partitions':
      command='scontrol show partitions'
    elif selected_function == 'job_details':
      jobid = event["queryStringParameters"]["jobid"]
      command='scontrol show jobs %s'%jobid
    elif selected_function == 'submit_job':
      script_name = ''.join([random.choice(string.ascii_letters + string.digits) for n in xrange(10)])
      jobscript_location = event["queryStringParameters"]["jobscript_location"]
      command = 'aws s3 cp s3://%s %s.sh; chmod +x %s.sh'%(jobscript_location,script_name,script_name)
      s3_tmp_out = execute_command(command,instance_id)
      submitopts = ''
      try:
        submitopts = event["headers"]["submitopts"]
      except Exception as e:
        submitopts = ''
      command = 'sbatch %s %s.sh'%(submitopts,script_name)
    body = execute_command(command,instance_id)
    return {
        'statusCode': 200,
        'body': body
    }
    
def execute_command(command,instance_id):
    runtime_region = os.environ['AWS_REGION']
    bucket_name = os.environ['MY_S3_BUCKET']
    ssm_client = boto3.client('ssm', region_name=runtime_region)
    s3 = boto3.resource('s3')
    bucket = s3.Bucket(bucket_name)
    username='ec2-user'
    response = ssm_client.send_command(
             InstanceIds=[
                "%s"%instance_id
                     ],
             DocumentName="AWS-RunShellScript",
             OutputS3BucketName=bucket_name,
             OutputS3KeyPrefix="ssm",
             Parameters={
                'commands':[
                     'sudo su - %s -c "%s"'%(username,command)
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
      output = ssm_client.get_command_invocation(CommandId=command_id,InstanceId=instance_id)
      if (output['Status'] == 'Failed') or (output['Status'] =='Cancelled') or (output['Status'] == 'TimedOut'):
        break
    body = ''
    files = list(bucket.objects.filter(Prefix='ssm/%s/%s/awsrunShellScript/0.awsrunShellScript'%(command_id,instance_id)))
    for obj in files:
      key = obj.key
      body += obj.get()['Body'].read()
    return body

```

7. In the **Environment variables** section, add the name of the S3 Bucket you created earlier. 

   Note: Do not modify the Key as it is used in the AWS Lambda function created above. Modify only the **Value** field with your S3 bucket name
![Lambda Env](/images/serverless/lambda-env.png)


8. In the **Basic settings** section, set 20 seconds as Timeout. Default is 3 seconds. 

9. Click **Deploy** in top right to save the function

10. In the **Execution role** section of **Basic settings**, choose **View the join-domain-function-role role on the IAM console**  as shown in the image below

![Lambda Basic Settings](/images/serverless/lambda-basic-set.png)

11. In the newly-opened IAM tab, choose **Attach Policy** and then **Create Policy**. This will open a new tab in your Browser. In this new tab, choose **Create policy** and then **Json**

12. Paste the below policy, modify the **<REGION>** and **<your-s3-bucket>** accordingly

```bash
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
                "arn:aws:s3:::pcluster-data/ssm"
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
                "arn:aws:s3:::<your-s3-bucket>",
                "arn:aws:s3:::<your-s3-bucket>/*"
            ]
        }
    ]
}
```

13. In the next section, give a **Name** to the policy (e.g. ExecuteSlurmCommandsPolicy) and select **Create policy**

14. In the previous tab, refresh the list, select the policy you created above and **Attach policy** as shown

15. **Save** changes to Lambda **Basic settings** 


 
{{% notice tip %}}
To learn more about the ParallelCluster Update Policies see [here](https://docs.aws.amazon.com/parallelcluster/latest/ug/using-pcluster-update.html)
{{% /notice %}}

