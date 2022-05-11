+++
title = "a. Deploy EC2 instance with NICE DCV"
date = 2019-01-24T09:05:54Z
weight = 140
tags = ["HPC", "NICE", "Visualization", "Remote Desktop", "Native Client"]
+++

In this section, you will create an Amazon EC2 instance with NICE DCV, then access it.

#### Create an Instance Profile for NICE DCV Licensing

The following steps use a CloudFormation template to create an instance profile, allowing the EC2 instance to access the NICE DCV licensing buckets:
```bash
curl https://www.hpcworkshops.com/scripts/dcv_license.zip -o dcv_license.zip
unzip dcv_license.zip
cd dcv_license
bash cfn_dcv_role.sh
cd ..
```

While waiting for the instance profile to be created, you can review the content in **cfn_dcv_role.sh** and **cfn_dcv_policy.yaml** to understand what the the behavior of the CloudFormation template. As described in [Licensing the NICE DCV Server](https://docs.aws.amazon.com/dcv/latest/adminguide/setting-up-license.html), the EC2 instance running the NICE DCV server must be able to reach the Amazon S3 endpoint and has permission to access the required S3 objects for NICE DCV licensing. The above-mentioned steps creates an instance profile (`DCVInstanceProfile-DCVBucketsInstanceProfile-xxxxxxxx`), with the following access policy:
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

#### Create an Amazon EC2 Instance with NICE DCV AMI

1. In the AWS Management Console search bar type **EC2** or click on the **EC2** tab in **Compute** section. This will take you to the EC2 dashboard

![NICE DCV EC2Launch](/images/nice-dcv/Launch-EC2.png)

2. Select **Instances** tab on left and click on **Launch Instance** 

![NICE DCV EC2Launch](/images/nice-dcv/Launch-EC2-2.png)

3. Choose an Amazon Machine Image (AMI): Select **AWS Marketplace** and search for **NICE DCV Linux**. Filter the results by **Amazon Linux OS**. Select the **NICE DCV for Amazon Linux 2**.

![NICE DCV EC2Launch](/images/nice-dcv/Launch-EC2-AMI.png)

4. Choose an Instance Type: You can choose a **g4dn.xlarge** which provides latest generation NVIDIA Tesla T4 GPUs and AWS custom Intel Cascade Lake CPUs. g4 instances are cost-effective for high performance graphics intensive applications. Select the g4dn.xlarge instance and choose **Next: Configure Instance Details**

![NICE DCV EC2Launch](/images/nice-dcv/Launch-EC2-InstanceType.png)

5. Configure Instance: In the Network section, select the same VPC ID and same Subnet ID from your AWS Cloud9 Instance. In the IAM role section, select the IAM instance profile we created a few minutes ago. Use the following command to find out the name of the instance profile:
```bash
aws cloudformation describe-stacks --stack-name DCVInstanceProfile --output text --query 'Stacks[0].Outputs[?OutputKey == `InstanceProfileARN`].OutputValue'
```

![NICE DCV EC2Launch](/images/nice-dcv/Launch-EC2-VPC-v2.png)

6. Add Storage: Choose **Next: Add Storage** and leave the Storage section with default settings.

7. Add Tags: Choose **Next: Add Tags**. Here you will tag your EC2 instance. Click on **Add Tag**, in the Key enter **Name** and in the Value enter **[Your Instance Name]**. This name is shown on EC2 Dashboard. Now, choose **Next: Configure Security Group**.

![NICE DCV EC2Launch](/images/nice-dcv/Launch-EC2-Tags.png)

8. Configure Security Group: Here you can control firewall rules that control traffic for your instance. Note that by default , the NICE DCV server communicates over port 8443. Since we use the NICE DCV AMI this port is already enabled by default. If not enabled by default, you need to enable SSH access by adding Port 22 to the Security Group. Click on **Add Rule**, choose **ssh** type, protocol **TCP**, port range **22** and source **0.0.0.0/0**.

![NICE DCV EC2Launch](/images/nice-dcv/Launch-EC2-SG.png)

9. Choose **Review and Launch**. Ignore any warning messages. 

10. On the review page, choose **Launch**, then select the **lab-your-key** [SSH key-pair](/02-aws-getting-started/05-key-pair-create.html) you created earlier. Click on **Launch Instances** 

11. Your instance is getting launched. Go to **EC2 Dashboard** and click on **Instances** to check status

![NICE DCV EC2Launch](/images/nice-dcv/Launch-EC2-FullInfo.png)

Next, we will connect to the instance.
