+++
title = "c. Publish to SNS topic"
date = 2019-09-18T10:46:30-04:00
weight = 350
tags = ["tutorial", "Monitoring", "ParallelCluster", "SNS", "Topic", "Publish"]
+++

In this section, you'll publish a test message to the SNS topic you created to confirm you can receive the notifications.

1. In the AWS Cloud9 terminal, login to the head node of your cluster (if not logged in already)

```bash
pcluster ssh perflab-yourname -i ~/.ssh/lab-4-key
```

### Publish a test message to the SNS topic

2. First check the subscription using **list-subscriptions-by-topic** command as follows:

```bash
aws sns list-subscriptions-by-topic --topic-arn $MY_SNS_TOPIC --region $REGION
```

3. Amazon SNS returns an output as following:
![SNS TOPIC](/images/monitoring/sns-topic-list.png)

4. Publish a test message to the topic using the **publish** command

```bash
aws sns publish --message "Verification" --topic $MY_SNS_TOPIC --region $REGION
```

5. Amazon SNS returns an output as following:
![SNS TOPIC](/images/monitoring/sns-topic-publish-msg.png)


6. Check your email to confirm that you received the message. You should have received an email as below:

![SNS TOPIC](/images/monitoring/sns-topic-publish-email.png)

Next, we will publish a job completion notification as part of your Slurm Job. 
