+++
title = "e. Retrieve the API endpoint URL"
date = 2019-09-18T10:46:30-04:00
weight = 70
tags = ["tutorial", "initialize", "ParallelCluster"]
+++

To call AWS ParallelCluster API, you need to retrieve the URL of its REST endpoint. This endpoint is provided as an output of the AWS ParallelCluster API stack and can be retrieved with the AWS CLI.

Run the following commands in a AWS Cloud9 terminal to retrieve the URL of the API endpoint:

```bash
# retrieve the AWS ParallelCluster API stack name
API_STACK_NAME=$(aws cloudformation describe-stacks --no-paginate --query 'Stacks[?StackName!=`null`]|[?contains(StackName, `ParallelClusterApi`) == `true`].StackName' --output text)
# get the API URL
export API_URL=$(aws cloudformation describe-stacks --no-paginate --stack-name ${API_STACK_NAME} --query 'Stacks[0].Outputs[?OutputKey==`ParallelClusterApiInvokeUrl`].OutputValue' --output text)
echo "AWS ParallelCluster API endpoint URL is: ${API_URL}"
```

Proceed to the next state to interact programmatically with AWS ParallelCluster API.
