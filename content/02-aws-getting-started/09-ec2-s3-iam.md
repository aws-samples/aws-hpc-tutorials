+++
title = "g. Opt - Create an IAM Role"
weight = 110
tags = ["tutorial", "cloud9", "aws cli", "ec2", "iam"]
+++

{{% notice info %}}
**You will encounter an issue with permissions now!** But, that's normal this section explains why.
{{% /notice %}}

{{% notice info %}}
Access to resources by users and services is controlled by [Identity and Access Management](https://aws.amazon.com/iam/) (IAM). For example, IAM permissions can be added to a policy then a role which can be attached to a user user, group role (admins, devops) or a service (Amazon EC2 to access Amazon S3, Amazon Lambda to access Amazon SQS). For an in depth introduction, see the [AWS Identity and Access Management User Guide](https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction.html).
{{% /notice %}}

Now that you have created an EC2 instance and logged into the instance using SSH, you can use the instance to access the Amazon S3 bucket created previously.

```bash
aws s3 ls s3://bucket-#YOUR_BUCKET_POSTFIX/ # <- use the postfix generated in previous steps
```

![EC2 SSH](/images/introductory-steps/ec2-iam-deny.png)

**It appears that your instances has not been granted permission to access your Amazon S3 storage.** Your AWS Cloud9 instance was [granted permissions](https://docs.aws.amazon.com/cloud9/latest/user-guide/credentials.html) to some services. However, your new Amazon EC2 instance has not been given any permissions. The next step is to grant the EC2 instance access to S3.


#### Create an IAM Role for Amazon EC2

Create a role so that your Amazon EC2 instance can access your S3 bucket.

1. In the AWS Management Console, choose **Services**, then **IAM**.
2. In the **IAM Dashboard**, in the left pane, choose **Roles**, then choose **Create Role**.
![IAM Dashboard](/images/introductory-steps/iam-dashboard.png)
3. For **Select type of trusted entity**, choose **AWS Service**.
4. For **Choose the service that will use this role**, choose **EC2**, and then choose **Next: Permissions**.
5. In the search field, type **S3** and choose the **AmazonS3FullAccess** policy to provide full Amazon S3 access for your Amazon EC2 instance.
6. Choose **Next: Tags** and leave the default settings.
7. Choose **Next: Review**.
8. Type a **Role Name**, such as **S3FullAccessForEC2**, then choose **Create Role**.

Your role is now created. Search for your role **S3FullAccessForEC2**. Selec the role to take a detailed look at the new role and policy. Select the **Trust Relationships** tab and you can see that Amazon EC2 is one of the trusted policies (meaning it can use this role).

![IAM Dashboard](/images/introductory-steps/iam-trust.png)

Select the **Permissions** tab and expand the **AmazonS3FullAccess** policy. Then, select **{}JSON**. You should see the permissions below. These permissions are open because they allow your Amazon EC2 instances to conduct any action on Amazon S3.

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": "*"
        }
    ]
}
```

However, you can also restrict these permissions to only some actions, such as List or Put, to be conducted on a particular Amazon S3 bucket. For example:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:Get*",
                "s3:List*"
            ],
            "Resource": [
                "arn:aws:s3:::bucket-myname",
                "arn:aws:s3:::bucket-myname/*"
            ]
        }
    ]
}
```
{{% notice info %}}
Note that full access to Amazon S3 is acceptable in the context of this workshop but fine-grained control is highly recommended for anything other than temporary sandbox testing.
{{% /notice %}}

IAM is a great way to control who and what can access which resources at a fine level of granularity. To learn more about IAM policies and the IAM Policy Simulator, see [Testing IAM Policies with the IAM Policy Simulator](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_testing-policies.html).

#### Attach the IAM Role to an Amazon EC2 Instance

Now that you have created a new IAM role, you can assign it to your EC2 instance:

1. Navigate to the **EC2 Dashboard** then choose **Instances**.
2. Choose your instance, then choose **Actions**, **Instance Settings**, and **Attach/Replace IAM Role**.
3. Select the newly created IAM Role, and choose **Apply**. Your role is attached and visible in your EC2 instance details. Your EC2 instance is now allowed to access S3.
![EC2 IAM Role](/images/introductory-steps/ec2-role.png)
4. Return to your AWS Cloud9 IDE, connect to the instance with SSH, and run the following commands (don't forget to change the bucket name to yours!). This command lists your Amazon S3 bucket content then downloads the file downloaded previously.
```bash
aws s3 ls s3://bucket-${BUCKET_POSTFIX}/
```
```bash
aws s3 cp s3://bucket-${BUCKET_POSTFIX}/SEG_C3NA_Velocity.sgy .
```
```bash
ls -l
```

You should see a result similar to the example shown in the following image.
![EC2 IAM Role](/images/introductory-steps/ec2-s3-ls.png)
