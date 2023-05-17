+++
title = "j. Summary and Cleanup"
date = 2019-09-18T10:46:30-04:00
weight = 100
tags = ["tutorial", "FSx", "summary"]
+++


In this workshop, you learned how to create an Amazon FSx for Lustre shared file system with AWS ParallelCluster. Then, you learned how lazy file loading works and conducted performance tests on the Lustre partition using IOR. Finally, you looked at the Lustre partition metrics and visualized these using Amazon CloudWatch.

Before moving to the next workshop, make sure to delete your cluster:

![Delete Cluster](/images/pcluster/pcmanager-delete.png)

By deleting the cluster the EC2 instances (head node and compute fleet) will be terminated. The **Amazon FSx for Lustre** file system will also be deleted as it was created by **AWS ParallelCluster** as part of the cluster.

However the data from that file system is still archived in your **Amazon S3** bucket.
You could use this **Amazon S3** bucket to populate another **Amazon FSx for Lustre** file system.

If you want to delete the bucket, you first have to delete all objects in it.
You can do this in the AWS Console or in your **AWS Cloud9** IDE terminal:

```bash
aws s3 rm s3://mybucket-${BUCKET_POSTFIX} --recursive
```
then you can remove the bucket:
```bash
aws s3 rb s3://mybucket-${BUCKET_POSTFIX}
```


{{% notice info %}}
For more information on Amazon FSx for Lustre capabilities, see the [Amazon FSx for Lustre User Guide](https://docs.aws.amazon.com/fsx/latest/LustreGuide/what-is.html).
{{% /notice %}}

