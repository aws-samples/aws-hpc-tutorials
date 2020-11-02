+++
title = "b. Setup SNS topic"
date = 2019-09-18T10:46:30-04:00
weight = 320
tags = ["tutorial", "Monitoring", "ParallelCluster", "SNS", "Topic"]
+++


First, create an SNS topic, then you publish a message directly to the topic to test that you have properly configured it

1. In the AWS Cloud9 terminal login to the head node of your cluster as below:

```bash
pcluster ssh perflab-yourname -i ~/.ssh/lab-4-key
```

### To set up an SNS topic

2. Configure your email address and AWS region

  - Enter your email address where you would like to receive the SNS notifications

```bash
MY_EMAIL_ADDRESS=<your-email-address>
```

  - Identify your AWS Region using the command below

```bash
REGION=`curl http://169.254.169.254/latest/dynamic/instance-identity/document|grep region|awk -F\" '{print $4}'`
```

3. Create the topic using the create-topic command as follows. 

```bash
MY_SNS_TOPIC=$(aws sns create-topic --name slurm-job-completion --region $REGION --output text)
echo $MY_SNS_TOPIC
```

### Subscribe to your created SNS topic

4. Subscribe your email address to the topic using the subscribe command. If the subscription request succeeds, you receive a confirmation email message.  

```bash
aws sns subscribe --topic-arn $MY_SNS_TOPIC --protocol email --notification-endpoint $MY_EMAIL_ADDRESS --region $REGION
```

   - Amazon SNS returns the following:

   ![SNS TOPIC](/images/monitoring/sns-topic-subscribe.png)

5. From your email application, open the message from AWS Notifications and confirm your subscription. 

![SNS TOPIC](/images/monitoring/sns-topic-email.png)

6. Your web browser displays a confirmation response from Amazon Simple Notification Service.

![SNS TOPIC](/images/monitoring/sns-topic-email-confirm.png)


Next, we will check the subscription and publish a test message to the topic.
