+++
title = "f. Set up a Job Definition"
date = 2019-09-18T10:46:30-04:00
weight = 80
tags = ["tutorial", "install", "AWS", "batch", "packer"]
+++

In this step, you set up a template used for your jobs, known as a job definition. A job definition is not required, but a good practice to use so that you can version how your jobs are launched. For more information about job definitions, see [Job Definitions](https://docs.aws.amazon.com/batch/latest/userguide/job_definitions.html).

1. In the **AWS Batch Dashboard**, choose **Job definitions**, then **Create**.
![AWS Batch](/images/aws-batch/batch10.png)
2. Type a **Job definition name**.
3. For **Job attempts**, type **5**. This option specifies the number of attempts before declaring a job as failed.
4. For **Execution timeout**, type **500**. This option specifies the time between attempts in seconds.
![AWS Batch](/images/aws-batch/batch11.png)
5. Skip to the **Environment** section.
6. For **Job role**, choose the role previously defined for ECS tasks to access the output S3 bucket on your behalf. If you do not know the name of the job role, use the following command in your terminal.
```bash
echo "ECS Job Role: $(aws cloudformation describe-stacks --stack-name PrepAVWorkshop --output text --query 'Stacks[0].Outputs[?OutputKey == `ECSTaskPolicytoS3`].OutputValue')"
```
7. For **Container image**, choose the **repositoryUri** generated when you created the ECR repository. If you do not know the URI, use the following commmand in your terminal.
```bash
aws ecr describe-repositories --repository-names carla-av-demo --output text --query 'repositories[0].[repositoryUri]'
```
8. For **vCPUs** type **8**.
9. For **Memory (MiB)** type **2000**.
![AWS Batch](/images/aws-batch/batch12.png)
10. Skip to the **Environment variables** section.
11. Choose **Add**. This environmental variable will tell the application running in your container where to export data.
12. For **Key**, type **EXPORT_S3_BUCKET_URL**. For **Value**, choose the bucket you previously created. To find the name of the S3 bucket, run the following command in your terminal or view the S3 Dashboard in your account.
```bash
echo "S3 Output Bucket: $(aws cloudformation describe-stacks --stack-name PrepAVWorkshop --output text --query 'Stacks[0].Outputs[?OutputKey == `OutputBucket`].OutputValue')"
```
![AWS Batch](/images/aws-batch/batch13.png)
13. Choose **Create**.

Next, take a closer look at the compute environment, job queue, and job definition you created.
