+++
title = "- Set the API parameters"
date = 2019-09-18T10:46:30-04:00
weight = 252
tags = ["tutorial", "serverless", "ParallelCluster", "Lambda", "Slurm", "API Gateway"]
+++

The list of parameters below are the ones that your serverless function will be interpreting. The API will just forward the HTTPS calls content as an JSON object to your function.

| Argument     | Description |
|--------------|---------------------------------------------------------------------------------------------------------------------|
| `instanceid` | Instance id of the head-node of your cluster.
| `function` | API function to execute, these are defined in your Lambda function. Accepted values are `list_jobs`, `list_nodes`, `list_partitions`, `job_details` and `submit_job`.
| `jobscript_location` | Location of a job script to execute, it must be stored on Amazon S3 in your case. It is required only when `function=submit_job`.
| `submitopts` | Submission parameters passed to the scheduler. They are optional and can be used when `function=submit_job`.


#### Retrieve a few parameters

Before interacting with your API you will need to gather some information such as the instance ID of your head-node and the API Gateway address you created in the previous section. For that you will need to **open** a terminal on your Cloud9 instance and use the following commands.


- **Head-node instance ID**: you will describe the instances using the command below. It will retrieve the ID of instances called Master which corresponds to your head-node.

    ```bash
    export HEAD_NODE_ID=$(aws ec2 describe-instances  --query 'Reservations[*].Instances[*].InstanceId' --filters Name=instance-state-name,Values=running Name=tag:Name,Values=Master --output text)
    echo "Your head-node ID is: ${HEAD_NODE_ID}"
    ```

- **API Gateway address**: to get this information you can run the command below.

    ```bash
    # let's set an environment variable to help us
    export API_GATEWAY_ID=$(aws apigateway get-rest-apis --query 'items[?name==`SlurmFrontEndAPI`].id' --output text)
    echo "Your API Gateway ID is: ${API_GATEWAY_ID}"
    ```

- Now set the `INVOKE_URL` environment variable in your terminal. This will allow you to avoid repeating this URL every time you initiate a command.

    ```bash
    # get the region first
    AWS_REGION=$(aws configure get region)
    # then do an export of INVOKE_URL
    export INVOKE_URL=https://${API_GATEWAY_ID}.execute-api.${AWS_REGION}.amazonaws.com/slurm
    echo "The URL to your API Gateway is ${INVOKE_URL}"
    ```
