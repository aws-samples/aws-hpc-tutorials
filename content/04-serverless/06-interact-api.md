+++
title = "f. Interact with the Slurm API"
date = 2019-09-18T10:46:30-04:00
weight = 250
tags = ["tutorial", "serverless", "ParallelCluster", "Lambda", "Slurm", "API Gateway"]
+++

The Slurm API created in the previous steps requires some parameters:

 - **instanceid** – the instance id of the Head node of your cluster

 - **function** – the API function to execute. Accepted values are **list_jobs**, **list_nodes**, **list_partitions**, **job_details** and **submit_job**

 - **jobscript_location** – the S3 bucket location of the job script (required only when **function=submit_job**) .

 - **submitopts** – the submission parameters passed to the scheduler (optional, can be used when **function=submit_job**).

1. Login back to the Cloud9 Terminal

2. The instance id of the Head node can be obtained using the AWS CLI command as below

   ```bash
   aws ec2 describe-instances --query 'Reservations[*].Instances[*].[Tags[?Key==`Name`]| [0].Value,InstanceId,InstanceType, PrivateIpAddress, PublicIpAddress]' --filters Name=instance-state-name,Values=running --output table
   ```
3. Examples of interaction with the API. Execute these commands from the Cloud9 console, without logging into your cluster

   - We will set a few variables to invoke the API using the curl commands below

     ```bash
     SLURM_REST_API_ID=`aws apigateway get-rest-apis --query 'items[?name==\`slurmAPI\`].id' --output text`

     AWS_REGION=`aws configure get region`

     INVOKE_URL=https://${SLURM_REST_API_ID}.execute-api.${AWS_REGION}.amazonaws.com/slurm

     INSTANCE_ID=<cluster-head-node-instance-id> # This is the instance ID from the head node obtained from step 2 above
     ```

   - To **list the nodes** in your cluster

     ```bash
        curl -s POST "${INVOKE_URL}/slurm?instanceid=${INSTANCE_ID}&function=list_nodes" # Note the function name "list_nodes"
     ```

   - To **list the partition** in your cluster

     ```bash
     curl -s POST "${INVOKE_URL}/slurm?instanceid=${INSTANCE_ID}&function=list_partitions" # Note the function name "list_partitions"
     ```

4. (Optional) Submit a HPCG job

   As an example we will run the High Performance Conjguate Gradient (HPCG) Benchmark without logging into the cluster head node.

   - We will submit the job using the Slurm API we created  and point to the job runscript in a S3 bucket
     **Note**: The **run-hpcg.sh** script passed in the command below downloads the open-source HPCG benchmark, compiles it and submits a Slurm job to run.


     ```bash

     curl -s POST "${INVOKE_URL}/slurm?instanceid=${INSTANCE_ID}&function=submit_job&jobscript_location=aws-hpc-workshops/run-hpcg.sh" -H 'submitopts: --job-name=HPCG --partition=ondemand'
     ```

   - Once you submit the job, you should see a message of the Slurm job submitted and the corresponding Job ID

   - List your jobs using the **list_jobs** function

     ```bash
     curl -s POST "${INVOKE_URL}/slurm?instanceid=${INSTANCE_ID}&function=list_jobs"
     ```

   - Note that the job script (run-hpcg.sh) submitted above downloads and compiles the HPCG benchmark and then submits another batch job to run it. When you list jobs after a few mins as above you will notice another job submitted for the HPCG run (check the different Job ID)

   -  You can get the job details of your JobId

      ```bash
      curl -s POST "${INVOKE_URL}/slurm?instanceid=${INSTANCE_ID}&function=job_details&jobid=<JOB-ID>" # Specify the JobId in the <JOB-ID> field
      ```
     ![SLURM JOB](/images/serverless/slurm-job-1.png)


Congratulations, you have successfully completed the Serverless Computing Lab.

In this lab you learnt how to interact with your cluster with slurm scheduler using the Amazon API Gateway. You created this by using Amazon API Gateway, AWS Lambda and AWS Systems Manager to simplify interation with the cluster without granting access to the Head node, thus improving overall security. You can extend the API by adding additional schedulers or interaction workflows and can be integrated with external applications.

Using a similar approach, you can also create a serverless API of the AWS ParallelCluster command line interface. You can create, monitor and teardown your cluster using an API. This makes it possible to integrate AWS ParallelCluster programatically with other applications running on-prem or in the AWS Cloud.

Next, we will teardown the cluster and the created resources in this lab.



