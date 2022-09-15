+++
title = "b. Create S3 bucket and upload test data"
date = 2019-09-18T10:46:30-04:00
weight = 80
tags = ["tutorial", "lustre", "FSx", "S3"]
+++

In this step, you will create a new [AWS S3](https://aws.amazon.com/s3/) bucket , upload test data into it. This bucket will be linked in the next step to the FSx for lustre filesystem created in the previous step. 

You can create S3 bucket either via AWS console or via AWS Cli. For this lab you are going to use AWS cli to create S3 bucket and upload data. However, later on you will also be able to take a look at the S3 console to view the bucket and its contents.

1. Navigate to your Cloud9 IDE and on the Cloud9 terminal create S3 bucket with unique name.

{{% notice info %}}
The bucket name must start with **s3://**.
Choose a random prefix, postfix, or append your name. 
{{% /notice %}}

```bash
BUCKET_POSTFIX=$(python3 -S -c "import uuid; print(str(uuid.uuid4().hex)[:10])")
BUCKET_NAME_DATA="bucketname-${BUCKET_POSTFIX}"
aws s3 mb s3://$BUCKET_NAME_DATA

cat << EOF
***** Take Note of Your Bucket Name *****
Bucket Name = $BUCKET_NAME_DATA
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

4. Upload the file to your S3 bucket using the following command:

```bash
aws s3 cp ./SEG_C3NA_Velocity.sgy s3://${BUCKET_NAME_DATA}/SEG_C3NA_Velocity.sgy
```

5. List the content of your bucket using the following command. Alternatively, you can view the [S3 Dashboard](https://console.aws.amazon.com/s3/) in the AWS Management Console and view your newly created bucket to see the file.

```bash
aws s3 ls s3://$BUCKET_NAME_DATA/
```

6. Delete the local version of the file using the command **rm** or the AWS Cloud9 IDE interface.

```bash
rm SEG_C3NA_Velocity.sgy
```

7. If you would like a view of S3 through the user interface  open the [Amazon S3 console] and click on your bucket name to find the newly uploaded file.

![views3upload](/images/fsx-for-lustre-hsm/views3upload.png)

