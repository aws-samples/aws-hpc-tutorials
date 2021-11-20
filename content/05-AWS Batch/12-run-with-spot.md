+++
title = "l. Optimize Cost with EC2 Spot"
date = 2019-09-18T10:46:30-04:00
weight = 120
tags = ["tutorial", "install", "AWS", "batch", "packer"]
+++

### Overview

[Amazon EC2 Spot Instances](https://aws.amazon.com/ec2/spot/) offer spare compute capacity available in the AWS cloud at steep discounts compared to On-Demand instances. Spot Instances enable you to optimize your costs on the AWS cloud and scale your application's throughput up to 10X for the same budget.

Spot Instances can be interrupted by EC2 with two minutes of notification when EC2 needs the capacity back. You can use Spot Instances for various fault-tolerant and flexible applications, such as big data, containerized workloads, high-performance computing (HPC), stateless web servers, rendering, CI/CD and other test & development workloads.

### Compute Environment with EC2 Spot

In this step, you will create a new Compute Environment to use Spot Instances to save on the compute cost and allow to run your batch jobs on a bigger scale when needed. You will be using the AWS CLI tool this time to learn more about how to interact with AWS Batch using the command tools.

Compute environments are [Amazon ECS](https://aws.amazon.com/ecs/) clusters consisting of one or more EC2 instance types, or simply as the number of vCPUs you want to use to run your jobs. For more information on the compute environments, see [Compute Environments](https://docs.aws.amazon.com/batch/latest/userguide/compute_environments.html).

1. In the **Cloud9** IDE, use a terminal window to execute this command to create a compute environment configurations file **ce-spot.json**

```bash
cd ~/environment/
export SUBNETS="$(aws ec2 describe-subnets | jq '.Subnets[].SubnetId'| sed '$!s/$/,/')"
export SECURITY_GROUP="$(aws ec2 describe-security-groups --filters Name=group-name,Values=default | jq '.SecurityGroups[].GroupId')"
cat > ce-spot.json << EOF
{
    "computeEnvironmentName": "stress-ng-spot",
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
            "Name": "stress-ng batch"
        },
        "bidPercentage": 100
    },
    "tags": {
        "Name": "stress-ng batch"
    }
}
EOF
```
1. Let's go through the file you just created and note the below:
   1. Setting the **Compute environment name** to **stress-ng-spot**.
   2. Under **Compute Resources**, we're setting the  **type** to **SPOT** This allows EC2 to provision instances using Spot capacity.
   3. For **Allowed instance types** and as a key best practice for using Spot, you should consider as many instance types as your workload allows. For this lab, we will be using **optimal** in addtion to C5, M5, R5 families. The wide selection of instance types and using **SPOT_CAPACITY_OPTIMIZED** for **Allocation strategy**, allow the **AWS Batch** to pick the optimal and less likely to be interrupted instances types for the required instances.
   4. Leave the default value of **0** for **Minimum vCPUs**. This allows your environment to scale down to zero instances when there are no jobs to run.
   5. For **Maximum vCPUs** leave the default of **256**. This is the upper bound for vCPUs across all concurrently running instances.
   6. To keep cost optimal, leave the default value for **Desired vCPUs** to **0** to allow sclaing down to **0** instances when there are no jobs running.

2. Now let's create the compute environment using the configurations file we just built.

```bash
aws batch create-compute-environment  --cli-input-json file://ce-spot.json
```


Let's continue to the next step to set up a job queue.

### Job Queue

In this step, you will set up a job queue. You submit your jobs to a queue and they are dispatched to compute environment(s) in order of priority. If you want to learn more about job queues, see [Job Queues](https://docs.aws.amazon.com/batch/latest/userguide/job_queues.html).

1. Run this command to create a new queue and attach the Spot compute environment to it.

```bash
aws batch create-job-queue --state ENABLED --job-queue-name stress-ng-queue-spot --priority 1 --compute-environment-order order=1,computeEnvironment=stress-ng-spot
```

2. Note the following in the last command:
   1. Setting the **Job Queue name** to **stress-ng-queue** and **State** to **Enabled**.
   2. We set the **Priority** to 1 for this workshop, but you can pick any value between 1 and 500. This option defines the priority of a job queue when a compute environment is shared across job queues. Job queues with a higher priority (or a higher integer value for the priority parameter) are evaluated first when associated with the same compute environment. Priority is determined in descending order, for example, a job queue with a priority value of 10 is given scheduling preference over a job queue with a priority value of 1.

3. Once the job queue is created, run this command to check its *State* is **ENABLED** and *Status* is **VALID**.

```bash
aws batch describe-job-queues --query 'jobQueues[*].[jobQueueName,state,status]' --output table
```


Continue to the next step to set up a job definition.
