+++
title = "g. Set up a Job Definition"
date = 2019-09-18T10:46:30-04:00
weight = 80
tags = ["tutorial", "install", "AWS", "batch", "packer"]
+++

In this step, you set up a template used for your jobs, known as a job definition. A job definition is not required, but a good practice to use so that you can version how your jobs are launched. For more information about job definitions, see [Job Definitions](https://docs.aws.amazon.com/batch/latest/userguide/job_definitions.html).

1. In the **AWS Batch Dashboard**, choose **Job definitions** from the left pane, then **Create**. Ignore the *Loading resources* message in the grid.
![AWS Batch](/images/aws-batch/job-def/job_def_create.png)
2. Type a **Job definition name**.
3. For **Job attempts**, type **5**. This option specifies the number of attempts before declaring a job as failed.
4. For **Execution timeout**, type **500**. This option specifies the time between attempts in seconds.
![AWS Batch](/images/aws-batch/job-def/job_def_create_2.png)
5. For **Container Image**, enter the **repositoryUri** generated when you created the ECR repository. If you do not know the URI, use the following command in your terminal.
```bash
aws ecr describe-repositories --repository-names carla-av-demo --output text --query 'repositories[0].[repositoryUri]'
```
6. Clear out the contents of the **Command** text box, as we don't want to run any command when your job runs.
6. For **vCPUs** type **4**.
7. For **Memory (MiB)** type **2048**.
8. Leave the value as blank for **Number of GPUs** field.
![AWS Batch](/images/aws-batch/job-def/job_def_container.png)
9. Expand the **Additional configuration** section.
10. For **Job role** and **Execution role**, choose the role previously defined for ECS tasks in **b. Workshop Initial Setup**. If you do not know the name of the job role, use the following command in your terminal to validate.
Do not select any values for **Volumes**, **Mount points**, and **Ulimits**.
```bash
echo "ECS Job Role: $(aws cloudformation describe-stacks --stack-name PrepAVWorkshop --output text --query 'Stacks[0].Outputs[?OutputKey == `ECSTaskPolicytoS3`].OutputValue')"

echo "ECS Job Exceution Role: $(aws cloudformation describe-stacks --stack-name PrepAVWorkshop --output text --query 'Stacks[0].Outputs[?OutputKey == `ECSJobExecutionRole`].OutputValue')"
```
![AWS Batch](/images/aws-batch/job-def/job_def_additional_config.png)
11. Skip to the **Environment variables** section.
12. Choose **Add environment variable**. This environmental variable will tell the application running in your container where to export data.
13. For **Name**, type **EXPORT_S3_BUCKET_URL**. For **Value**, choose the bucket you previously created. To find the name of the S3 bucket, run the following command in your terminal or view the S3 Dashboard in your account.
```bash
echo "S3 Output Bucket: $(aws cloudformation describe-stacks --stack-name PrepAVWorkshop --output text --query 'Stacks[0].Outputs[?OutputKey == `OutputBucket`].OutputValue')"
```
![AWS Batch](/images/aws-batch/job-def/job_def_env_variable.png)
14. Scroll towards the bottom of the page and Choose **Create**.
![AWS Batch](/images/aws-batch/job-def/job_def_create_3.png)
15. Once the Job definition is ready, it will be visible under **Job definitions** grid. Make sure *Status* is **ACTIVE**.
![AWS Batch](/images/aws-batch/job-def/job_def_display.png)

Next, take a closer look at **compute environment**, **job queue**, and **job definition** you created.
