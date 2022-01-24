+++
title = "i. Run a Single Job"
date = 2019-09-18T10:46:30-04:00
weight = 100
tags = ["tutorial", "install", "AWS", "batch", "Docker"]
+++

### Run a Batch Job using the Console.

1. Click on **Jobs** in the menu on the left side.
2. Click on **Submit new job** button at the top right.
![AWS Batch](/images/aws-batch/run-job-1.png)
4. Name your job **stress-ng-job**.
5. For Job definition select **stress-ng-job-definition:1**.
6. Select **stress-ng-queue** as the **Job queue**.
7. Enter **120** in **Execution timeout**.
8. Leave the **Job attempts** as 3.
![AWS Batch](/images/aws-batch/run-job-2.png)
10. Select **Single** as the **Job type**.
![AWS Batch](/images/aws-batch/run-job-3.png)
11. Expand the **Additional configuration** section.
12. Under **Environment variables**, click **Add**.
13. Set **Name** to: STRESS_ARGS
14. Set **Value** to: `--cpu 0 --cpu-method fft --timeout 1m --times`
![AWS Batch](/images/aws-batch/run-job-4.png)
15. Scroll to the bottom and click **Submit**.
![AWS Batch](/images/aws-batch/run-job-5.png)

### Observe batch job status.
1. Click on **Dashboard** in the left side menu of the AWS Batch console. You will see a summary of the status your **Jobs, Job queues and Compute environments**.
![AWS Batch](/images/aws-batch/observe-job-1.png)
1. You can click on any of the stages of the Job queues to view the jobs in that state and then click on individual jobs to view their detailed properties and status. 
2. Click on the name of an individual job to view the detailed **Job information**.
![AWS Batch](/images/aws-batch/observe-job-2.png)
3. Click on the link below **Log stream name**. This will take you to the AWS CloudWatch log for the job which contains all of the STDOUT and STDERR output from the job.
4. If your job ran successfully you will see similar times and summary information to that which you saw when you ran the container locally on your Cloud9 instance.
![AWS Batch](/images/aws-batch/observe-job-3.png)


### Run a Batch job from the AWS CLI.

In this step, you will [submit a single job](https://docs.aws.amazon.com/batch/latest/userguide/submit_job.html) using the AWS CLI.

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
                "value": "--cpu 0 --cpu-method fft -t 1m --times"
            }
        ]
    }
}
EOF
aws batch submit-job --cli-input-json file://job.json
```

Note that you are using a structured JSON file to supply the required parameters of **jobName**, **jobQueue**, and **jobDefinition** as well as defining and passing the environment variable **STRESS_ARGS** that your container's docker-entrypoint.sh script uses to form the full stress-ng command-line. 

{{% notice info %}}
If the job does not run, double-check that the job queue name and job definition are correct.
{{% /notice %}}

Take note of the **Job Id** because you can use it to check the status of a job:

```
aws batch describe-jobs --jobs YOUR-JOB-ID
```
The returned *JSON* output displays and describes the status of you job.

#### JSON Output Processing

It's sometimes useful to capture of the job information at the time of submission for later use. 

Execute the following to install the "jq" utility to allow extraction of relevant fields from the JSON output.

```bash
sudo yum -y install jq
```

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
