___

## title: "Updates" date: 2019-09-18T10:50:17-04:00 draft: false weight: 20

{{% notice info  %}}
Frequently asked questions will be addressed on this page during the tutorial. Do not hesitate to visit this page often during the tutorial!
{{% /notice %}}

#### Accounts access

Sandbox are available on Novemver 14th 2021 for the duration of the tutorial. If you would like to run through the labs at a later stage on your own, with your company or institution, please contact us at sc21tutorial@amazon.com so we can follow-up with you.

#### You must specify a region issue

Several attendees shared that they encountered the error below when creating the IAM policy for their cluster in [**Lab II**](</04-serverless/02-serverless-iam/02-iam-policy2.html>). This was caused by a recent update. The responsible party has been tasked in learning French and bake enough [Tarte au Framboises](<http://nathaliebakes.com/tartes/tarte-aux-framboises-lenotre/>) to feed the team after SC21.

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
