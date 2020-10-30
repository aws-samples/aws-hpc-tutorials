+++
title = "- Adding environment variables"
date = 2019-09-18T10:46:30-04:00
weight = 175
tags = ["tutorial", "IAM", "ParallelCluster", "Serverless"]
+++

Environment variables are one way to provide parameters to a Lambda function. Accessing these variables is the same as retrieving your *Shell* environment variables via the function `os.environ` in Python.

1. We start by scrolling to the **Environment variables** section of your Lambda Panel, it is located below the *Function code* section.
2. Click on **Manage environment variables**, then click on **Add environment variables**
![Lambda Create Function](/images/serverless/lambda-create5.png)
3. In the **Key** text box, enter the text `MY_S3_BUCKET`, in the **Value** field add the name of the S3 bucket that as created during [the very first step](/04-serverless/02-iam-policy-serverless.html).
![Lambda Create Function](/images/serverless/lambda-create6.png)
