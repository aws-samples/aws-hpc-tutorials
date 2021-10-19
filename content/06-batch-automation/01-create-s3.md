+++
title = "a. Create S3 bucket"
date = 2019-09-18T10:46:30-04:00
weight = 120
tags = ["tutorial", "install", "AWS", "Batch"]
+++

In this step, we will create a S3 bucket to store the results of your Nextflow simulations



1. In the AWS Management Console search bar, type and select Cloud9.

2. Choose open IDE for the Cloud9 instance set up previously. It may take a few moments for the IDE to open. AWS Cloud9 stops and restarts the instance so that you do not pay compute charges when no longer using the Cloud9 IDE.

3. Create your unique S3 bucket using the following command

```bash
BUCKET_NAME=nextflow-results
BUCKET_POSTFIX=$(uuidgen --random | cut -d'-' -f1)
aws s3 mb s3://${BUCKET_NAME}-${BUCKET_POSTFIX}

cat << EOF 
***** Take Note of Your Bucket Name ********
Bucket Name = ${BUCKET_NAME}-${BUCKET_POSTFIX}
***************************************
EOF

```

{{% notice info %}}
Keep note of your bucket name. If you forget your bucket name, you can view it in the [Amazon S3 Dashboard](https://s3.console.aws.amazon.com/s3/home).
{{% /notice %}}


