---
title: "Amazon SNS Notification"
date: 2019-01-24T09:05:54Z
weight: 270
tags: ["HPC", "Performance", "Monitoring", "Notification", "SNS"]
---

![SNS](/images/monitoring/sns.png)

[Amazon Simple Notification Service](https://aws.amazon.com/sns/) (Amazon SNS) is a managed service that provides message delivery from publishers to subscribers (also known as producers and consumers). Publishers communicate asynchronously with subscribers by sending messages to a topic, which is a logical access point and communication channel. Clients can subscribe to the SNS topic and receive published messages using a supported protocol, such as Amazon SQS, AWS Lambda, HTTP, email, mobile push notifications, and mobile text messages (SMS)

In this lab, you will set up Amazon SNS Notifications for your HPC Cluster jobs. You will get a job completion notification via email at the end of your Slurm job run. 

This lab includes the following steps:

  1. Update the IAM Role and attach a Policy to give **AmazonSNSFullAccess** to the cluster
  2. Create the topic
  3. Subscribe your email address to the topic
  4. Publish a message to the topic from your Cluster Job
  5. Check your email to confirm that you received the message.

{{% notice info %}}This lab requires an AWS Cloud9 IDE. If you do not have an AWS Cloud9 IDE set up, complete sections *a. Sign in to the Console* through *d. Work with the AWS CLI* in the [**Getting Started in the Cloud**](/02-aws-getting-started.html) workshop. 
{{% /notice %}}
