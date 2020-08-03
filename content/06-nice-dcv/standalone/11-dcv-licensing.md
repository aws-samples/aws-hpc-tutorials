+++
title = "d. NICE DCV Licensing"
date = 2019-09-18T10:46:30-04:00
weight = 200
tags = ["HPC", "NICE", "Visualization", "Remote Desktop", "Web Browser", "Native Client"]
+++

When you connect to NICE DCV using the NICE DCV client, you might notice the following notification regarding NICE DCV licensing.
![DCV Terminate](/images/nice-dcv/nice-dcv-licensing.png)

When you have the NICE DCV server running on Amazon EC2 instances, you do not need to install a license server for NICE DCV. Instead, the NICE DCV server automatically detects that it is running on an Amazon EC2 instance and periodically connects to an S3 bucket to determine whether a valid license is available. As such, the EC2 instance needs to be able to reach the S3 service, and has the permission to access the required S3 object. 

The following steps use a CloudFormation template to create an instance profile, allowing the EC2 instance to access the NICE DCV licensing buckets:
```bash
curl https://s3.amazonaws.com/av-workshop/dcv_license.zip -o dcv_license.zip
unzip dcv_license.zip
cd dcv_license
bash dcv_dcv_role.sh
cd ..
```

In short, the above-mentioned steps creates an instance profile, with the following access policy:
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::dcv-license.<region>/*"
        }
    ]
}
```

Use the following command to find out the actual name of the instance profile:
```bash
aws cloudformation describe-stacks --stack-name DCVWorkshop --output text --query 'Stacks[0].Outputs[?OutputKey == `InstanceProfileARN`].OutputValue'
```

In the EC2 console, select the EC2 instance. Click on **Actions -> Instance Settings -> Attach/Replace IAM Role** to attach an IAM Role to the EC2 instance.
![DCV Terminate](/images/nice-dcv/nice-dcv-iam-1.png)

Select the above-mentioned instance profile. Click on the **Apply** button to attach the role to the EC2 instance. After a few minutes, the notification regarding NICE DCV licensing will disappear from the NICE DCV client.
![DCV Terminate](/images/nice-dcv/nice-dcv-iam-2.png)

You can refer to [Licensing the NICE DCV Server](https://docs.aws.amazon.com/dcv/latest/adminguide/setting-up-license.html) for more information on NICE DCV licensing.


