+++
title = "- Attach the IAM policy to the role"
date = 2019-09-18T10:46:30-04:00
weight = 187
tags = ["tutorial", "IAM", "ParallelCluster", "Serverless"]
+++
Now you will attach the policy you have created to the role that your Lambda function assumes.


1. You will need the name of the default execution role created by AWS Lambda shown in [**section f**](/04-serverless/06-slurm-lambda-config/06-config2.html). You can get the name of this role using the AWS CLI as shown below. It should be called SlurmFrontEnd-role-XYZ where XYZ is a random string

   ```bash
   aws iam list-roles --query "Roles[*].[RoleName]" --output=text | grep "SlurmFrontEnd-role"
   ```

2. Next, you will attach the IAM policy you created in the previous step to the role. You will need the Amazon Resource Name (ARN) of the created policy. The below gets the ARN

   ```bash
   LAMBDA_IAM_POLICY=$(aws iam list-policies --query 'Policies[?PolicyName==`lambda-exec`].Arn' --output text)
   echo $LAMBDA_IAM_POLICY
   ```

3. Apply the policy to the role. Remember to replace the **SlurmFrontEnd-role-XYZ** to the exact name of your role

   ```bash
   aws iam attach-role-policy --role-name SlurmFrontEnd-role-XYZ --policy-arn $LAMBDA_IAM_POLICY
   ```

     {{%expand "If you run into a security token error, expand the below to see how to fix it" %}}

   Copy the AWS credentials information from Event Engine AWS Console login page as shown below

   ![Event Engine](/images/serverless/event-engine-creds.png)
    
   Paste the credentials information copied above in your AWS Cloud9 Terminal. 

   Once done re-try the above step of applying the LAMBDA_IAM_POLICY to the LAMBDA IAM role.

    {{% /expand%}}

4. You can confirm the policy attached to the role as shown below. Replace the role name **SlurmFrontEnd-role-XYZ** to the exact name of your role.

   ```bash
   aws iam list-attached-role-policies --role-name SlurmFrontEnd-role-XYZ
   ```

5. You should see an output as below. Confirm that your policy (**lambda-exec**) is attached to the role.
![Lambda IAM ](/images/serverless/lambda-iam-role-list-policy.png)

You are done with IAM and Lambda. Do not hesitate to explore the services you discovered beyond this tutorial. Next, you will attach your AWS Lambda function to Amazon API Gateway.

{{% notice note %}}
As an exercise you can trying creating the above AWS Lambda function using AWS Console.
{{% /notice %}}
