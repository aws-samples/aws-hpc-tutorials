+++
title = "f. Check the auto export feature"
date = 2019-09-18T10:46:30-04:00
weight = 130
tags = ["tutorial", "lustre", "FSx", "S3"]
+++

In this section you will test out the auto-export feature of FSx to data repository S3 and verify presence the new data in the S3 bucket. . 

1. You will next test **auto export**. When we created the data repository association we chose to go with automatic export from FSx file system to the S3 bucket. To test this, let us just create a 10MB file on the file system and then verify on the S3 bucket.

```bash
sudo chown -R ec2-user /fsx/
cd /fsx/hsmtest
truncate -s 10M export_test_file
ls -lh
```

2. Go to the [Amazon S3 console](https://s3.console.aws.amazon.com/s3/home), click on the bucket you created in section b. Here you should be seeing the newly created file **export_test_file** of 10M automatically copied into S3 bucket. This verifies the auto export of this data repository association.

![exportfile](/images/fsx-for-lustre-hsm/exportfile.png)


![verifys3export](/images/fsx-for-lustre-hsm/verifys3export.png)

