+++
title = "- Create the lambda IAM policy"
date = 2019-09-18T10:46:30-04:00
weight = 185
tags = ["tutorial", "IAM", "ParallelCluster", "Serverless"]
+++

Go back to your AWS Cloud9 terminal as you will update the AWS Lambda created execution role using the AWS CLI

You will first create a new IAM policy document with the required permissions and apply that to the role. Before you do that you will need to have the ID of the current AWS region and the name of the S3 bucket previously created. If you don't remember those you can run the commands below in your AWS Cloud9 terminal.

1. Retrieve the current AWS region ID:

   ```bash
   #Install dependencies
   sudo yum -y install jq
   export AWS_REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region)
   ```

2. List your Amazon S3 buckets and pick the one you just created. It should be called serverless-XYZ where XYZ is a random string.

    ```bash
    aws s3api list-buckets --query "Buckets[].Name" --output table
    ```

3. Set the following variable with your S3 bucket name. Remember to replace the **\<your-s3-bucket-name\>** with the exact name of your bucket.

   ```bash
   export MY_S3_BUCKET=<your-s3-bucket-name>
   ```

4. Create a new policy text document (**lambda-policy**) in JSON format with the required permissions for your Lambda function. This policy enables your Lambda function to access AWS Systems Manager (SSM). Copy paste the following


    ```bash
    cat > lambda-policy << EOF
    {
    "Version": "2012-10-17",
    "Statement": [{
        "Effect": "Allow",
        "Action": ["ssm:SendCommand"],
        "Resource": [
          "arn:aws:ec2:$REGION:*:instance/*",
          "arn:aws:ssm:$REGION::document/AWS-RunShellScript",
          "arn:aws:s3:::$MY_S3_BUCKET/ssm"]
    }, {
        "Effect": "Allow",
        "Action": ["ssm:GetCommandInvocation"],
        "Resource": ["arn:aws:ssm:$REGION:*:*"]
    }, {
        "Effect": "Allow",
        "Action": ["s3:*"],
        "Resource": [
          "arn:aws:s3:::$MY_S3_BUCKET",
          "arn:aws:s3:::$MY_S3_BUCKET/*"]
    }]
    }
    EOF
    ```

5. Create the IAM policy using the following command
   ```bash
   aws iam create-policy --policy-name lambda-exec --policy-document file://lambda-policy
   ```
6. You should see an ouput as below
![Lambda IAM ](/images/serverless/lambda-iam-create-policy.png)
7. Now you have created a new IAM policy (policy name **lambda-exec**) with the necessary permissions for your Lambda function. Next, we will apply this policy to the Lambda created execution role

  
