---
title: "Updates"
date: 2019-09-18T10:50:17-04:00
draft: false
weight: 20
---

{{% notice info  %}}
Frequently asked questions will be addressed on this page during the tutorial. Do not hesitate to visit this page often during the tutorial!
{{% /notice %}}

#### Accounts access

Accounts took some time to be delivered and we are sorry that some of the attendees received them late in the tutorial. We will find a better mechanism next time to deliver the credentials in a timely manner. If you're still waiting for credentials please email us again at sc20tutorial@amazon.com.


#### You must specify a region issue

Several attendees shared that they encountered the error below when creating the IAM policy for their cluster in [**Lab II**](/04-serverless/02-serverless-iam/02-iam-policy2.html). This was caused by a recent update. The responsible party has been tasked in learning French and bake enough [Tarte au Framboises](http://nathaliebakes.com/tartes/tarte-aux-framboises-lenotre/) to feed the team after SC20.

```
aws cloudformation create-stack --stack-name pc-serverless-policy --parameters ParameterKey=S3Bucket,ParameterValue=serverless-${BUCKET_POSTFIX} --template-body file://serverless-template.yaml --capabilities CAPABILITY_NAMED_IAM, it replies : You must specify a region. You can also configure your region by running “aws configure”.
```

You can use the following command to solve this issue:

```bash
export AWS_REGION=$(aws configure get region)
```

#### Running from the head-node instead of the head node

If you can't run the commands of the tutorial, please ensure that you are running on AWS Cloud9. If in doubt you can run the command below.

```bash
if [ -d /etc/parallelcluster/ ]; then exit; fi
```
