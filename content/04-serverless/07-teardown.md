+++
title = "f. Teardown the cluster and resources"
date = 2019-09-18T10:46:30-04:00
weight = 250 
tags = ["tutorial", "serverless", "ParallelCluster", "Lambda", "Slurm", "API Gateway"]
+++


1. Delete the cluster created using ParallelCluster

   ```bash
   pcluster delete <your-cluster-name>
   ```

2. Delete the API in API Gateway

   - Go to AWS Management Console -> Services -> API Gateway

   - Click on the slurmAPI created and Actions -> Delete

   ![Teardown API](/images/serverless/teardown-api-gateway.png)


3. Delete the Lambda Function

   - Go to AWS Management Console -> Services -> Lambda 

   - Click on the slurmAPI function and Actions -> Delete

   ![Teardown Lambda](/images/serverless/teardown-lambda.png)





