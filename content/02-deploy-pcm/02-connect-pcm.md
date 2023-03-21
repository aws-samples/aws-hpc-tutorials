+++
title = "b. Connect to ParallelCluster UI"
weight = 32
tags = ["tutorial", "cloud9", "ParallelCluster"]
+++

1. Got to the AWS Console, in the search box search for [**AWS CloudFormation**](https://console.aws.amazon.com/cloudformation/home) and click on that service.

2. You'll see a stack named **parallelcluster-ui**, click on that stack > **Outputs** Tab then click on the **ParallelClusterUIURL** to connect.

![ParallelCluster UI Deployed](/images/deploy-pcm/pcluster-deployed.png)

3. During deployment you received an email titled **[AWS ParallelCluster UI] Welcome to ParallelCluster UI, please verify your account.**. Copy the password from that email.

> From: “no-reply@verificationemail.com” no-reply@verificationemail.com Date: Monday, February 20, 2023 at 1:00 PM To: you@email.com Subject: [AWS ParallelCluster UI] Welcome to AWS ParallelCluster UI, please verify your account.

> You are invited to manage clusters with ParallelCluster UI. Your administrator will contact you with the link to access. Your username is you@email.com and your temporary password is XXXXXX (you will need to change it in your first access).

4. **Enter the credentials**  using the *email* you used when deploying the stack and the *temporary password* from the email above.

![ParallelCluster UI CloudFormation Stack](/images/deploy-pcm/pcmanager-creds.png)

4. You will be asked to provide a new password. Enter a new password to complete signup.

![Signup Screen](/images/deploy-pcm/signup.png)

Congrats! You are ready to create your HPC cluster in AWS. Let's do that in the next section.