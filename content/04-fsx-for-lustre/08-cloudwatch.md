+++
title = "h. View Metrics with CloudWatch"
date = 2019-09-18T10:46:30-04:00
weight = 80
tags = ["tutorial", "IOR", "FSx", "metrics"]
+++


In this step, you visualize the metrics related to your Amazon FSx for Lustre file system using CloudWatch. You can graph [several metrics](https://docs.aws.amazon.com/fsx/latest/LustreGuide/monitoring_overview.html) such as the throughput and IOPs. You can also create alarms or display [more evolved metrics](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/using-metric-math.html#adding-metrics-expression-console).

This example looks at the IOPS and free space on the file system as shown in the image below.

![IOR Result](/images/06-fsx-for-lustre/fsx-cloudwatch.png)

To produce a similar graph, follow these steps:

1. In the AWS Management Console, in the search field, search for and choose **Amazon FSx**. Then, select [File systems](https://console.aws.amazon.com/fsx/home?region=us-east-1#file-systems) (three bars on the left side).
2. **Take note** of your file system ID, it should be similar to *fs-0a5444e4841233*.
3. In the AWS Management Console, in the search field, search for and choose **CloudWatch**. Choose [**Metrics**](https://console.aws.amazon.com/cloudwatch/home?region=us-east-1#cw:dashboard=Home), then **FSx**.
4. Select the following metrics for the file system with the same ID as noted above: **FreeDataStorageCapacity**, **DataWriteOperations**, and **DataReadOperations**.
5. Set the **FreeDataStorageCapacity** to be displayed based on the **right Y Axis**.

If you want, you can add this graph to a dashboard or build additional metrics as discussed [here](https://docs.aws.amazon.com/fsx/latest/LustreGuide/how_to_use_metrics.html). In addition, you can [set alarms](https://docs.aws.amazon.com/fsx/latest/LustreGuide/creating_alarms.html) to send notifications on events, such as low storage capacity or high bandwidth utilization. Those notifications can be used to trigger a Lambda function to create and attach a larger file system to your EC2 instances using [CloudWatch Events](https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/WhatIsCloudWatchEvents.html) or to send you an email with information about your environment status.
