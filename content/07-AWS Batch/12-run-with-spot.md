+++
title = "m. Optimize Cost with EC2 Spot"
date = 2019-09-18T10:46:30-04:00
weight = 120
tags = ["tutorial", "install", "AWS", "batch", "packer"]
+++

### Overview

Many customers use [Amazon EC2 Spot Instances](https://aws.amazon.com/ec2/spot/) to save on their compute cost. In this step you will learn how to use Spot Instances to run batch jobs and how to configure your AWS Batch Jobs to handle infrastructure events like Spot interruption.

[Amazon EC2 Spot Instances](https://aws.amazon.com/ec2/spot/) offer spare compute capacity available in the AWS cloud at steep discounts compared to On-Demand instances. Spot Instances enable you to optimize your costs on the AWS cloud and scale your application's throughput up to 10X for the same budget.

Spot Instances can be interrupted by EC2 with two minutes of notification when EC2 needs the capacity back. You can use Spot Instances for various fault-tolerant and flexible applications, such as big data, containerized workloads, high-performance computing (HPC), stateless web servers, rendering, CI/CD and other test & development workloads.

{{% notice note %}}
This step depends on completing the previous one, if you haven't done it, please go to **Job Dependencies** and complete it first. In this step you will re-run the last exercise of **Submit Leader and Follower jobs with a dependency** but this time with a separate job queue and a new compute environment that uses Spot Instances.
{{% /notice %}}

### Compute Environment with EC2 Spot

In this step, you will create a new Compute Environment to use Spot Instances to save on the compute cost and allow to run your batch jobs on a bigger scale when needed. You will be using the AWS CLI tool this time to learn more about how to interact with AWS Batch using the command tools.

Compute environments are [Amazon ECS](https://aws.amazon.com/ecs/) clusters consisting of one or more EC2 instance types, or simply as the number of vCPUs you want to use to run your jobs. For more information on the compute environments, see [Compute Environments](https://docs.aws.amazon.com/batch/latest/userguide/compute_environments.html).

1. In the **Cloud9** IDE, use a terminal window to execute this command to create a compute environment config file **ce-spot.json**

```bash
cd ~/environment/
export SUBNETS="$(aws ec2 describe-subnets | jq '.Subnets[].SubnetId'| sed '$!s/$/,/')"
export SECURITY_GROUP="$(aws ec2 describe-security-groups --filters Name=group-name,Values=default | jq '.SecurityGroups[].GroupId')"
cat > ce-spot.json << EOF
{
    "computeEnvironmentName": "stress-ng-ce-spot",
    "type": "MANAGED",
    "state": "ENABLED",
    "computeResources": {
        "type": "SPOT",
        "allocationStrategy": "SPOT_CAPACITY_OPTIMIZED",
        "minvCpus": 0,
        "maxvCpus": 256,
        "desiredvCpus": 0,
        "instanceTypes": [
            "c5",
            "m5",
            "r5",
            "optimal"
        ],
        "subnets": [
            ${SUBNETS}
        ],
        "securityGroupIds": [
            ${SECURITY_GROUP}
        ],
        "instanceRole": "ecsInstanceRole",
        "tags": {
            "Name": "stress-ng batch spot"
        },
        "bidPercentage": 100
    },
    "tags": {
        "Name": "stress-ng batch spot"
    }
}
EOF
```
1. Let's go through the file you just created and note the below:
   1. Setting the **Compute environment name** to **stress-ng-ce-spot**.
   2. Under **Compute Resources**, we're setting the  **type** to **SPOT** This allows EC2 to provision instances using Spot capacity.
   3. For **Allowed instance types** and as a key best practice for using Spot, you should consider as many instance types as your workload allows. For this lab, we will be using **optimal** in addition to C5, M5, R5 families. The wide selection of instance types and using **SPOT_CAPACITY_OPTIMIZED** for **Allocation strategy**, allow the **AWS Batch** to pick the optimal and less likely to be interrupted instances types for the required instances.
   4. Leave the default value of **0** for **Minimum vCPUs**. This allows your environment to scale down to zero instances when there are no jobs to run.
   5. For **Maximum vCPUs** leave the default of **256**. This is the upper bound for vCPUs across all concurrently running instances.
   6. To keep cost optimal, leave the default value for **Desired vCPUs** to **0** to allow scaling down to **0** instances when there are no jobs running.

2. Now let's create the compute environment using the configurations file we just built.

```bash
aws batch create-compute-environment  --cli-input-json file://ce-spot.json
```

3. This should take few minutes, use the following command to check on the status of the compute environment.
```bash
aws batch describe-compute-environments | jq '.computeEnvironments[] |select(.computeEnvironmentName=="stress-ng-ce-spot")'
```

Let's continue to the next step to set up a new job queue.

### Job Queue

In this step, you will set up a job queue. You submit your jobs to a queue and they are dispatched to compute environment(s) in order of priority. If you want to learn more about job queues, see [Job Queues](https://docs.aws.amazon.com/batch/latest/userguide/job_queues.html).

1. Run this command to create a new queue and attach the Spot compute environment to it.

```bash
aws batch create-job-queue --state ENABLED --job-queue-name stress-ng-queue-spot --priority 1 --compute-environment-order order=1,computeEnvironment=stress-ng-ce-spot
```

2. Note the following in the last command:
   1. Setting the **Job Queue name** to **stress-ng-queue** and **State** to **Enabled**.
   2. We set the **Priority** to 1 for this workshop, but you can pick any value between 1 and 500. This option defines the priority of a job queue when a compute environment is shared across job queues. Job queues with a higher priority (or a higher integer value for the priority parameter) are evaluated first when associated with the same compute environment. Priority is determined in descending order, for example, a job queue with a priority value of 10 is given scheduling preference over a job queue with a priority value of 1.

3. Once the job queue is created, run this command to check its *State* is **ENABLED** and *Status* is **VALID**.

```bash
aws batch describe-job-queues --query 'jobQueues[*].[jobQueueName,state,status]' --output table
```


Continue to the next step to set up a new job definition.

As in the previous example, you will submit the two jobs **Leader** and **Follower** and specify a dependency such that the Leader job runs first and the Follower array job will only start upon successful completion of the Leader job. You will continue to submit the Leader job to a queue that's connected to On-Demand EC2 instances, assuming this job can't be interrupted and we will avoid running it on Spot Instances.

The difference in this step, you will submit the **Follower** jobs to a separate queue that sends jobs to the Spot compute environment you just created. And to allow the **Follower** tasks to restart in case of failure due to Spot interruptions, you will update the job definition as per the below steps definition.

### Follower job definition

Execute the following commands to create a new job definition for the Follower job. 
{{% notice info %}}
As a best practice for Spot interruptions handling: Set a Retry Strategy - as in the below command - which allows the task to restart if the instances running it gets terminated due to a Spot instance reclaim. Learn more about [Retry strategies](https://docs.aws.amazon.com/batch/latest/userguide/job_definition_parameters.html#retryStrategy)
{{% /notice %}}


```bash
cd ~/environment/dependency/follower
export STACK_NAME=BatchWorkshop
export EXECUTION_ROLE="$(aws cloudformation describe-stacks --stack-name $STACK_NAME --output text --query 'Stacks[0].Outputs[?OutputKey == `JobExecutionRole`].OutputValue')"
export EXECUTION_ROLE_ARN=$(aws iam get-role --role-name $EXECUTION_ROLE | jq -r '.Role.Arn')
export FOLLOWER_REPO=$(aws ecr describe-repositories --repository-names stress-ng-follower --output text --query 'repositories[0].[repositoryUri]')
cat > stress-ng-follower-spot-job-definition.json << EOF
{
    "jobDefinitionName": "stress-ng-follower-spot-job-definition",
    "type": "container",
    "containerProperties": {
        "image": "${FOLLOWER_REPO}",
        "vcpus": 1,
        "memory": 1024,
        "jobRoleArn": "${EXECUTION_ROLE_ARN}",
        "executionRoleArn": "${EXECUTION_ROLE_ARN}"
    },
    "retryStrategy": { 
        "attempts": 5,
        "evaluateOnExit": 
        [{
            "onStatusReason" :"Host EC2*",
            "action": "RETRY"
        },{
            "onReason" : "*",
            "action": "EXIT"
        }]
    }
}
EOF
aws batch register-job-definition --cli-input-json file://stress-ng-follower-spot-job-definition.json
```

Execute the following commands to create a JSON file of job options for the Follower job. Notice the Job Queue name is set to the Spot queue.

```bash
export STACK_NAME=BatchWorkshop
export STRESS_BUCKET="s3://$(aws cloudformation describe-stacks --stack-name $STACK_NAME --output text --query 'Stacks[0].Outputs[?OutputKey == `Bucket`].OutputValue')"
cat <<EOF > ./stress-ng-follower-spot-job.json
{
    "jobName": "stress-ng-follower-spot",
    "jobQueue": "stress-ng-queue-spot",
    "arrayProperties": {
        "size": 2
    },
    "jobDefinition": "stress-ng-follower-spot-job-definition",
    "containerOverrides": {
        "environment": [
        {
            "name": "STRESS_BUCKET",
            "value": "${STRESS_BUCKET}"
        }]
    }
}
EOF
```


### Submit Leader and Follower jobs with a dependency

1. Empty your S3 bucket by executing the following commands.
   
```bash
export STRESS_BUCKET="s3://$(aws cloudformation describe-stacks --stack-name $STACK_NAME --output text --query 'Stacks[0].Outputs[?OutputKey == `Bucket`].OutputValue')"
aws s3 rm ${STRESS_BUCKET} --recursive
```

2. Execute the following commands to submit a Leader job and a Follower array job with a dependency on the successful completion of the Leader.

```bash
### Submit the Leader job and determine its jobID.
cd ~/environment/dependency
export LEADER_JOB=$(aws batch submit-job --cli-input-json file://leader/stress-ng-leader-job.json)
echo "${LEADER_JOB}"
export LEADER_JOB_ID=$(echo ${LEADER_JOB} | jq -r '.jobId')
echo "${LEADER_JOB_ID}"
### Submit the Follower array job with a dependency on the Leader jobID.
export FOLLOWER_JOB=$(aws batch submit-job --cli-input-json file://follower/stress-ng-follower-spot-job.json --depends-on jobId="${LEADER_JOB_ID}",type="N_TO_N" --array-properties size=12)
export FOLLOWER_JOB_ID=$(echo ${FOLLOWER_JOB} | jq -r '.jobId')
echo "${FOLLOWER_JOB_ID}"
```

3. Check the description of the Follower job by executing the following command.

```bash
aws batch describe-jobs --jobs ${FOLLOWER_JOB_ID}
```

You will see the dependency on the Leader job in the returned job description. You can also view this dependency by navigating to a member task of the Follower job in the AWS Batch dashboard.

Your Leader job should complete successfully followed by the Follower job array and eventually the output from the 12 tasks of the job array will appear in the S3 bucket.

{{% notice tip %}}
To test how the **Follower** jobs will react in case of Spot instance being interrupted: 1)Resubmit both jobs. 2) Wait for the **Follower** tasks to be in **Running** state. 3) Navigate to [AWS EC2 Console](https://console.aws.amazon.com/ec2) and terminate the instances tagged with "stress-ng batch spot".
{{% /notice %}}
