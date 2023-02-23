---
title : "d. Clean up workshop resources"
weight : 40
---

To avoid unexpected charges to your account relative to this workshop, make sure you delete the cluster and associated resources.

1. First, you need to clean up the S3 buckets:
```bash
source ~/envVars-$AWS_REGION
aws s3 rm --recursive s3://$INPUT_BUCKET/
aws s3 rm --recursive s3://$RESULT_BUCKET/
aws s3 rm --recursive s3://$INPUT_BUCKET-logs/
```
2. Then you can delete the repository created earlier to store the image for both AWS Batch and Lambda with the following command:

```bash
aws ecr delete-repository --repository-name fsi-demo --force --region $AWS_REGION
```

3. As you learned how to create the infrastructure with AWS command line in previous sections, you are going to delete the stacks deployed with [CloudFormation console](https://console.aws.amazon.com/cloudformation/home#/stacks) as an alternative way for operations. After identifying the "fsi" stacks and choose which one to delete, you can delete the two stacks one after the other by clicking the "Delete" button.

![cloudformation](/images/batch-lambda/delete-stacks.png)


4. Now you are ready to delete the [Cloud9 environment](https://console.aws.amazon.com/cloud9/) created for this workshop:
![cloud9](/images/batch-lambda/delete-cloud9.png)

5. Find the IAM role used for this workshop from the [IAM console](https://console.aws.amazon.com/iamv2/home#/roles) and delete the IAM role created for Cloud9 
![iam-role](/images/batch-lambda/delete-IAM-role.png)

6. At the end, you will delete the CloudWatch log groups created for this workshop by choosing "Delete log group(s)" from [CloudWatch console](https://console.aws.amazon.com/cloudwatch/home#logsV2:log-groups)
![log-groups](/images/batch-lambda/delete-log-groups.png)





