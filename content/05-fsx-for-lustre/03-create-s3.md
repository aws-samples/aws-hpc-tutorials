+++
title = "c. Create S3 Bucket"
date = 2019-09-18T10:46:30-04:00
weight = 30
tags = ["configuration", "FSx", "ParallelCluster"]
+++

#### Create an Amazon S3 Bucket and Upload Files

1. On your Cloud9 instance, run the following commands to create a new Amazon S3 bucket. These commands also retrieve and store two example files in this bucket [MatrixMarket](https://math.nist.gov/MatrixMarket/) and a velocity model from the [Society of Exploration Geophysicists](https://wiki.seg.org/wiki/SEG_C3_45_shot).

```bash
# generate a uniqe postfix
BUCKET_POSTFIX=$(uuidgen --random | cut -d'-' -f1)
echo "export BUCKET_POSTFIX=${BUCKET_POSTFIX}" >> ~/.bashrc
echo "Your bucket name will be mybucket-${BUCKET_POSTFIX}"
aws s3 mb s3://mybucket-${BUCKET_POSTFIX}

# retrieve local copies
wget https://math.nist.gov/pub/MatrixMarket2/misc/cylshell/s3dkq4m2.mtx.gz
wget http://s3.amazonaws.com/open.source.geoscience/open_data/seg_eage_salt/SEG_C3NA_Velocity.sgy

# upload to your bucket
aws s3 cp s3dkq4m2.mtx.gz s3://mybucket-${BUCKET_POSTFIX}/s3dkq4m2.mtx.gz
aws s3 cp SEG_C3NA_Velocity.sgy s3://mybucket-${BUCKET_POSTFIX}/SEG_C3NA_Velocity.sgy

# delete local copies
rm s3dkq4m2.mtx.gz
rm SEG_C3NA_Velocity.sgy
```

Before continuing to the next step, check the content of your bucket using the AWS CLI with the command:

```bash
aws s3 ls s3://mybucket-${BUCKET_POSTFIX}
```

You should see two files:

```bash
2022-06-22 21:55:12  477086544 SEG_C3NA_Velocity.sgy
2022-06-22 21:55:11   13027582 s3dkq4m2.mtx.gz
```

Next we're going to link the S3 bucket to the filesystem we just created.
