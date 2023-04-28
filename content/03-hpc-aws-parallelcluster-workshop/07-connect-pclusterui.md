+++
title = "g. Connect to PCluster Manager"
date = 2019-09-18T10:46:30-04:00
weight = 60
tags = ["tutorial", "initialize", "ParallelCluster"]
+++

Once your PCluster Manager CloudFormation stack has been deployed, you can follow these steps to connect to it:

1. Go to the AWS Console, in the search box search for [**AWS CloudFormation**](https://console.aws.amazon.com/cloudformation/home) and click on that service.

2. You'll see a stack named **parallelcluster-ui**, click on that stack > **Outputs** Tab then click on the **ParallelClusterUIURL** to connect.

{{% notice info %}}
If you're interested in customizing the URL (outside of workshop time) please see [Setup Custom Domain 🔗](https://pcluster.cloud/02-tutorials/08-custom-domain.html).
{{% /notice %}}

![ParallelCluster UI Deployed](/images/hpc-aws-parallelcluster-workshop/lab1-pcluster-workshop-07-pcluster-deployed.png)

3. During deployment you received an email titled **[AWS ParallelCluster UI] Welcome to ParallelCluster UI, please verify your account.**. Copy the password from that email.

> From: “no-reply@verificationemail.com” no-reply@verificationemail.com Date: Monday, February 20, 2023 at 1:00 PM To: you@email.com Subject: [AWS ParallelCluster UI] Welcome to AWS ParallelCluster UI, please verify your account.

> You are invited to manage clusters with ParallelCluster UI. Your administrator will contact you with the link to access. Your username is you@email.com and your temporary password is XXXXXX (you will need to change it in your first access).
4. **Enter the credentials**  using the *email* you used when deploying the stack and the *temporary password* from the email above.

![ParallelCluster UI CloudFormation Stack](/images/hpc-aws-parallelcluster-workshop/lab1-pcluster-workshop-07-pcmanager-creds.png)

4. You will be asked to provide a new password. Enter a new password to complete signup.

![Signup Screen](/images/hpc-aws-parallelcluster-workshop/lab1-pcluster-workshop-07-signup.png)

You can now sign in to your cluster management UI. On doing so, you should either see the cluster still being created:

![Creation in progress](/images/hpc-aws-parallelcluster-workshop/lab1-pcluster-workshop-07-cluster-creation-in-progress.png)

Or creation will be complete:

![Creation Complete](/images/hpc-aws-parallelcluster-workshop/lab1-pcluster-workshop-07-cluster-creation-complete.png)

Next you will do a dry run cluster creation using the ParallelCluster UI to familiarise yourself with the steps taken earlier.