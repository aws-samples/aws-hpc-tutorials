+++
title = "- Create the S3 Bucket"
date = 2019-09-18T10:46:30-04:00
weight = 55
tags = ["tutorial", "IAM", "ParallelCluster", "Serverless"]
+++

Let's start by creating a new S3 bucket.

To make sure you're on the **Cloud9** instance and not the cluster we created earlier, run:

```bash
if [ -d /etc/parallelcluster/ ]; then exit; fi
```

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
{{% notice note %}}
Please keep track of your S3 bucket name as you will use it later.
{{% /notice %}}

