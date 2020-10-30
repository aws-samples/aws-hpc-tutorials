+++
title = "i. Call your API through HTTP"
date = 2019-09-18T10:46:30-04:00
weight = 250
tags = ["tutorial", "serverless", "ParallelCluster", "Lambda", "Slurm", "API Gateway"]
+++

In the previous sections, you created a serverless function then binded a API Gateway to this function and trigger it using HTTP calls. This function translates the arguments provided to the API Gateway, then connect to the head node through a secure channel and execute the commands. In this section we will use with new our HTTP API and interact with Slurm using [cURL](https://en.wikipedia.org/wiki/CURL).

#### API Parameters

The list of parameters below are the ones that our Serverless function will be interpreting. The API will just forward the HTTP calls content as an JSON object to our function.

| Argument     | Description |
|--------------|---------------------------------------------------------------------------------------------------------------------|
| `instanceid` | Instance id of the head-node of your cluster.
| `function` | API function to execute, these are defined in your Lambda function. Accepted values are `list_jobs`, `list_nodes`, `list_partitions`, `job_details` and `submit_job`.
| `jobscript_location` | Location of a job script to execute, it must be stored on Amazon S3 in our case. It required only when `function=submit_job`.
| `submitopts` | Submission parameters passed to the scheduler. They are optional and can be used when `function=submit_job`.


#### Retrieve a few parameters

Before interacting with your API you will need to gather some information such as the instance ID of your head-node and the API Gateway address we created in the previous section. For that you will need to **open** a terminal on your Cloud9 instance and use the following commands.


- **Head-node instance ID**: you will describe the instances using the command below. In the second column you will see a list of IDs, please pick the one corresponding to your head node.

    ```bash
    aws ec2 describe-instances --query 'Reservations[*].Instances[*].[Tags[?Key==`Name`]| [0].Value,InstanceId,InstanceType, PrivateIpAddress, PublicIpAddress]' --filters Name=instance-state-name,Values=running --output table
    ```
    Now `export` the environment variable `HEAD_NODE_ID` with the value corresponding to your head-node. This will simplify our future interactions with the API.



- **API Gateway address**: to get this information you can run the command below.

    ```bash
    aws apigateway get-rest-apis --query 'items[?name==\`SlurmFrontEndAPI\`].id' --output text
    # let's set an environment variable to help us
    export API_GATEWAY_ID=$(aws apigateway get-rest-apis --query 'items[?name==\`SlurmFrontEndAPI\`].id' --output text)
    ```

- Now set the `INVOKE_URL` environment variable in your terminal. This will allow you to avoid repeating this URL every time you initiate a command.

    ```bash
    # get the region first
    AWS_REGION=$(aws configure get region)
    # then do an export of INVOKE_URL
    export INVOKE_URL=https://${API_GATEWAY_ID}.execute-api.${AWS_REGION}.amazonaws.com/slurm
    ```

#### Interact with your API

To interact wit your API you will be using [cURL](https://en.wikipedia.org/wiki/CURL), it is a tool commonly used to interact with HTTP(s) servers. cURL is already installed on your Cloud9 instance.

1. Without logging into your cluster, start by running the following command in the Cloud9 terminal to **list the compute nodes** attached to your Slurm cluster.

      ```bash
         curl -s POST "${INVOKE_URL}/slurm?instanceid=${HEAD_NODE_ID}&function=list_nodes" # Note the function name  "list_nodes"
      ```
2. Initiate a second cURL call to **list the partitions** in your cluster

      ```bash
      curl -s POST "${INVOKE_URL}/slurm?instanceid=${HEAD_NODE_ID}&function=list_partitions" # Note the function name "list_partitions"
      ```
#### Submitting jobs through cURL

You began interacting with the API to list jobs and partitions. Let's take this exercise a bit further and submit a job by running the High Performance Conjugate Gradient (HPCG) Benchmark. Again without logging into the cluster head node. The job runscript that you will provide to `sbatch` is already stored on an S3 bucket. You can download it if you like to view its contents.

1. Run the following command to submit, compile and run HPCCG.

     ```bash
     curl -s POST "${INVOKE_URL}/slurm?instanceid=${HEAD_NODE_ID}&function=submit_job&jobscript_location=aws-hpc-workshops/run-hpcg.sh" -H 'submitopts: --job-name=HPCG --partition=ondemand'
     ```

2. Once the job is submitted, you should see a message indicating that it has been submitted to Slurm and with its corresponding Job ID. List the jobs using the `list_jobs` function to check its status.

      ```bash
      curl -s POST "${INVOKE_URL}/slurm?instanceid=${INSTANCE_ID}&function=list_jobs"
      ```
   {{% notice info %}}
   The job script `run-hpcg.sh`  downloads and compiles the HPCG benchmark and then submits another batch job to run it. When you list jobs after a few mins as above you will notice another job submitted for the HPCG run (check the Job IDs)
   {{% /notice %}}


3. To get more details about your job, use the function `job_details` while replacing the `<JOB-ID>` string with the ID of your HPCG job.

      ```bash
      curl -s POST "${INVOKE_URL}/slurm?instanceid=${INSTANCE_ID}&function=job_details&jobid=<JOB-ID>" # Specify the JobId in the <JOB-ID> field
      ```

4. You should see a result similar to the one below

![SLURM JOB](/images/serverless/slurm-job-1.png)


{{% notice info %}}
Now that you know how to submit jobs and check their details. Would you take the challenge of building a new submission script starting from `job`? Use the following command to upload your job script to one of your buckets when ready : `aws s3 cp <path-to-local-file> s3://<YOUR_BUCKET>/<NAME_OF_YOUR_FILE> --acl public-read`
{{% /notice %}}
