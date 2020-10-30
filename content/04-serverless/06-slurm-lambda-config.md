+++
title = "f. Configure the function"
date = 2019-09-18T10:46:30-04:00
weight = 170
tags = ["tutorial", "serverless", "ParallelCluster", "Lambda", "Slurm"]
+++

Now that we have added the code of our function we will add an environment variable then change the timeout of the function which is the maximum time this function is allowed to run.

#### Adding environment variables

Environment variables are one way to provide parameters to a Lambda function. Accessing these variables is the same as retrieving your *Shell* environment variables via the function `os.environ` in Python.

1. We start by scrolling to the **Environment variables** section of your Lambda Panel, it is located below the *Function code* section.
2. Click on **Manage environment variables**, then click on **Add environment variables**
![Lambda Create Function](/images/serverless/lambda-create5.png)
3. In the **Key** text box, enter the text `MY_S3_BUCKET`, in the **Value** field add the name of the S3 bucket that as created during [the very first step](/04-serverless/02-iam-policy-serverless.html).
![Lambda Create Function](/images/serverless/lambda-create6.png)


#### Configure the function timeout

Now we will configure the timeout for your function, it is the time after which it will be declared failed.

1. Click on **Edit** in the **Basic settings**. They are located below the **Environment variables**.
![Lambda Create Function](/images/serverless/lambda-create7.png)
2. In the section **Timeout**, increase the seconds from 3 to 20.
![Lambda Create Function](/images/serverless/lambda-create8.png)
3. Then scroll down, you will see a section **Execution role**, the select radio button should be **Use an existing role**. The role is the one created by default when you initiated the function. Click on the link **View the serverless-something role on the IAM console** as shown in the red box below of the image below.
![Lambda Create Function](/images/serverless/lambda-create9.png)
4. A new tab will open in your web-browser and point to IAM. You can go back to the previous tab with the Lambda Basic settings and click on **Save**. Then go back to the newly opened tab. We'll work on this one during the next section.
![Lambda Create Function](/images/serverless/lambda-create10.png)

Now we will focus on IAM to modify the role for your lambda function in order to add the access rights required it needs to operate.

