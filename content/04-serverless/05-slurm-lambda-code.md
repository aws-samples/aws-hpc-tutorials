+++
title = "e. Add code to your function"
date = 2019-09-18T10:46:30-04:00
weight = 160
tags = ["tutorial", "serverless", "ParallelCluster", "Lambda", "Slurm"]
+++

Now that you have created the Lambda function, you will add code to transform the HTTP requests to our cluster head - node through the channel offered by AWS Systems Manager(SSM). Let's add the code of the function by following this series of steps:

1. On the Lambda Function panel, scroll until you reach the section **Function code**
![Lambda Create Function](/images/serverless/lambda-create4.png)

2. Copy the code below in to the editor window called `lambda_function`. This function takes the event sent by API gateway and based on the query parameters will execute a Slurm command.
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
        script_name = ''.join([random.choice(string.ascii_letters + string.digits) for n in range(10)])
        jobscript_location = event["queryStringParameters"]["jobscript_location"]
        command = 'aws s3 cp s3://%s %s.sh; chmod +x %s.sh' % (jobscript_location, script_name, script_name)
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
          'body': body
      }


    def execute_command(command, instance_id):
      runtime_region = os.environ['AWS_REGION']
      bucket_name = os.environ['MY_S3_BUCKET']
      ssm_client = boto3.client('ssm', region_name=runtime_region)
      s3 = boto3.resource('s3')
      bucket = s3.Bucket(bucket_name)
      username = 'ec2-user'
      response = ssm_client.send_command(
               InstanceIds=[
                  "%s" % instance_id
                       ],
               DocumentName="AWS-RunShellScript",
               OutputS3BucketName=bucket_name,
               OutputS3KeyPrefix="ssm",
               Parameters={
                  'commands': [
                       'sudo su - %s -c "%s"' % (username, command)
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
        output = ssm_client.get_command_invocation(CommandId=command_id, InstanceId=instance_id)
        if (output['Status'] == 'Failed') or (output['Status'] == 'Cancelled') or (output['Status'] == 'TimedOut'):
          break
      body = ''
      files = list(bucket.objects.filter(Prefix='ssm/%s/%s/awsrunShellScript/0.awsrunShellScript' % (command_id, instance_id)))
      for obj in files:
        key = obj.key
        body += obj.get()['Body'].read().decode("utf-8", 'backslashreplace')
      return body
    ```

3. Click **Deploy** in top right to save the function. When done, you will be informed that it has been successfully deployed. Now that you have deployed our function you need to add an environment variable and increase the timeout.
