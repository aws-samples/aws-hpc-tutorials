+++
title = "d. Opt - Create an S3 Bucket"
weight = 80
tags = ["tutorial", "cloud9", "s3"]
+++

Now that you have access to the AWS CLI, you can use it to create an S3 bucket, then upload a file to this bucket. You can later use this bucket to load files into Lustre. For more information Amazon S3, see [Amazon Simple Storage Service Documentation](https://docs.aws.amazon.com/s3/index.html).
Alternatively, you can also perform these steps in the AWS Management Console, but this workshop uses AWS CLI.

1. Open a Cloud9 terminal and enter the following command to list existing buckets. (This command may return several or no buckets.)
```bash
aws s3 ls
```
2. Create an S3 bucket with a unique name using the following command.

{{% notice info %}}
The bucket name must start with **s3://**.
Choose a random prefix, postfix, or append your name.
{{% /notice %}}

```bash
BUCKET_POSTFIX=$(uuidgen --random | cut -d'-' -f1)
aws s3 mb s3://bucket-${BUCKET_POSTFIX}

cat << EOF
***** Take Note of Your Bucket Name *****
Bucket Name = bucket-${BUCKET_POSTFIX}
*****************************************
EOF


```
{{% notice info %}}
Keep note of your bucket name. If you forget your bucket name, you can view it in the [Amazon S3 Dashboard](https://s3.console.aws.amazon.com/s3/home).
{{% /notice %}}
3. Download a file from the Internet to your Cloud9 instance. For example, download [synthetic subsurface model](https://wiki.seg.org/wiki/SEG_C3_45_shot). The file will be downloaded on your AWS Cloud9 instance, not your computer.
```bash
wget http://s3.amazonaws.com/open.source.geoscience/open_data/seg_eage_salt/SEG_C3NA_Velocity.sgy
```
<!-- I tested both the aws s3 cp and wget versions. Results are as follows: cp = 9 sec, wget = 7 sec -->
4. Upload the file to your S3 bucket using the following command:
```bash
aws s3 cp ./SEG_C3NA_Velocity.sgy s3://bucket-${BUCKET_POSTFIX}/SEG_C3NA_Velocity.sgy
```
5. List the content of your bucket using the following command. Alternatively, you can view the [S3 Dashboard](https://console.aws.amazon.com/s3/) in the AWS Management Console and view your newly created bucket to see the file.
```bash
aws s3 ls s3://bucket-${BUCKET_POSTFIX}/
```
6. Delete the local version of the file using the command **rm** or the AWS Cloud9 IDE interface.
```bash
rm SEG_C3NA_Velocity.sgy
```
Example: Creating an S3 bucket in Cloud9 (click to enlarge):
![Cloud9 AWS CLI](/images/introductory-steps/cloud9-aws-cli.png)

Example: Viewing an S3 bucket in the S3 Dashboard (click to enlarge):
![Cloud9 S3 AWS Console](/images/introductory-steps/cloud9-s3.png)



