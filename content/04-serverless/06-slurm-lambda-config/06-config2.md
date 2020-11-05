+++
title = "- Configure the function timeout"
date = 2019-09-18T10:46:30-04:00
weight = 177
tags = ["tutorial", "IAM", "ParallelCluster", "Serverless"]
+++


Now you will configure the timeout for your function, it is the time after which it will be declared failed.

1. Click on **Edit** in the **Basic settings**. They are located below the **Environment variables**.
![Lambda Create Function](/images/serverless/lambda-create7.png)
2. In the section **Timeout**, increase the seconds from 3 to 20.
![Lambda Create Function](/images/serverless/lambda-create8.png)
3. Then scroll down, you will see a section **Execution role**, the select radio button should be **Use an existing role**. The role is the one created by default when you initiated the function. Note down the name of this role since you will modify it to provide additional access rights. Here the name of the role is **SlurmFrontEnd-role-\<uniq-hash\>** as shown in the red box of the image below. 
![Lambda Create Function](/images/serverless/lambda-create9.png)
4. Click on **Save** for the updated Lambda Basic settings.
![Lambda Create Function](/images/serverless/lambda-create10.png)

Now you will focus on IAM to modify the role for your lambda function in order to add the access rights it needs to operate.
