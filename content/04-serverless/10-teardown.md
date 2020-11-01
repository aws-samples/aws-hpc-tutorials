+++
title = "j. Summary & cleanup"
date = 2019-09-18T10:46:30-04:00
weight = 300
tags = ["tutorial", "serverless", "ParallelCluster", "Lambda", "Slurm", "API Gateway"]
+++


In this lab you learned how to use serverless functions on AWS Lambda and make them interact with other services such as a REST API with Amazon API Gateway and connect to your cluster using a secure channel through AWS Systems Manager. This allowed you to let users interact with you cluster without granting access to the head-node nor exposing the SSH port which grants you with an additional level of security. You can extend the API by implementing new interfaces to Slurm commands, adding other schedulers or develop new workflows to copy files automatically when a job is finished.

Using a similar approach, you can also create a serverless API of the AWS ParallelCluster command line interface. You can create, monitor and teardown your cluster using an API. This makes it possible to integrate AWS ParallelCluster programmatically with other applications running on-prem or in the AWS Cloud.

Next, you will teardown the cluster and the resources you created in this lab.


#### Cleaning up your resources

1. Delete the cluster created using AWS ParallelCluster using the terminal in your AWS Cloud9 IDE. Replace `<your-cluster-name>` by the name of your cluster

   ```bash
   pcluster delete <your-cluster-name>
   ```

2. You will now delete the API in API Gateway

   - Go to **AWS Management Console**, select **Services**, the click on **AWS API Gateway**

   - Select on the **slurmFrontEndAPI** you created earlier. Then click on the **Actions** button and select **Delete**. You will be asked to validate the deletion, follwo the instructions

   ![Teardown API](/images/serverless/teardown1.png)


3. Finalize the cleanup by removing the Lambda Function. To do so, go to the **AWS Management Console**, click on **Services** and select **AWS Lambda**. Go to **Functions** and select the function **SlurmFrontEnd**. Click on the button **Actions**, then select **Delete**. Follow the instructions to validate the deletion of your function

   ![Teardown Lambda](/images/serverless/teardown2.png)





