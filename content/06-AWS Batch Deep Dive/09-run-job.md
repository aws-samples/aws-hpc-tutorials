+++
title = "i. Run a Single Job"
date = 2019-09-18T10:46:30-04:00
weight = 100
tags = ["tutorial", "install", "AWS", "batch", "Docker"]
+++

### Run a Batch Job from the AWS Management Console.

1. In the [**AWS Batch dashboard**](https://console.aws.amazon.com/batch/home), choose **Jobs** in the menu on the left side.
2. Click on **Submit new job** button at the top right.
![AWS Batch](/images/aws-batch/run-job-1.png)
4. For **Name** type **stress-ng-job**.
5. For **Job definition** select **stress-ng-job-definition:1** (the ":1" suffix signifies version 1).
6. Select **stress-ng-queue** as the **Job queue**.
7. Enter **120** in **Execution timeout**. Here you are overriding the previous value of 180 seconds you provided in the Job Definition.
![AWS Batch](/images/aws-batch/run-job-2.png)
8. Under **Job configuration** select the **Environment variables configuration** toggle.
9. Set **Name** to: **STRESS_ARGS**
10. Set **Value** to: 
    ```text
    --cpu 0 --cpu-method fft --timeout 1m --times
    ```
![AWS Batch](/images/aws-batch/run-job-3.png)
11.  Scroll to the bottom and click **Submit**.
![AWS Batch](/images/aws-batch/run-job-4.png)

### Observe batch job status.
1. Click on **Dashboard** in the left side menu of the AWS Batch console. You will see a summary of the status your **Jobs, Job queues and Compute environments**.
![AWS Batch](/images/aws-batch/observe-job-1.png)
1. You can click on any of the stages of the Job queues to view the jobs in that state and then click on individual jobs to view their detailed properties and status. 
2. Click on the name of an individual job to view the detailed **Job information**.
![AWS Batch](/images/aws-batch/observe-job-2.png)
3. Click on the link below **Log stream name**. This will take you to the **AWS CloudWatch** log for the job which contains all of the output (STDOUT and STDERR) from the job.
4. If your job ran successfully you will see similar output to that which you saw when you ran the container locally on your Cloud9 instance.
![AWS Batch](/images/aws-batch/observe-job-3.png)


### Run a Batch job from the AWS CLI.

In this step, you will [submit a job](https://docs.aws.amazon.com/cli/latest/reference/batch/submit-job.html) using the AWS CLI.

1. Execute the following commands in a terminal window on your Cloud9 instance. 


```bash
cat > job.json << EOF
{
    "jobName": "stress-ng-1",
    "jobQueue": "stress-ng-queue",
    "jobDefinition": "stress-ng-job-definition:1",
    "containerOverrides": {
        "environment": [
            {
                "name": "STRESS_ARGS",
                "value": "--cpu 0 --cpu-method fft --timeout 1m --times"
            }
        ]
    }
}
EOF
aws batch submit-job --cli-input-json file://job.json
```

Note that you are creating a structured JSON file to supply the required parameters of **jobName**, **jobQueue**, and **jobDefinition** as well as defining and passing the environment variable **STRESS_ARGS** used by your container's docker-entrypoint.sh script to form the full stress-ng command-line. 

{{% notice info %}}
If the job does not run, double-check that the job queue name, job definition name and version are correct.
{{% /notice %}}

Take note of the **jobId** returned when you sumbitted the job. You can use this to check the status of the job using the following command (replacing YOUR_JOB_ID with the jobId value returned previously):

```
aws batch describe-jobs --jobs YOUR-JOB-ID
```
The returned *JSON* output displays and describes the status of your job.

#### JSON Output Processing

It's sometimes useful to capture of the job information at the time of submission for later use. 

Use "jq" utility to allow extraction of relevant fields from the JSON output.

Execute the following commands:
```bash
export JOB_INFO=$(aws batch submit-job --cli-input-json file://job.json)
export JOB_ID=$(echo ${JOB_INFO} | jq -r '.jobId')
aws batch describe-jobs --jobs ${JOB_ID}
```

These commands:
- Submit a job in the same manner as above and capture the returned JSON job information to an environment variable JOB_INFO
- Process the JSON format job information to extract the **jobId** field
- Use the **jobId** to report the status of the job
