+++
title = "b. Connect to Pcluster Manager"
weight = 32
tags = ["tutorial", "cloud9", "ParallelCluster"]
+++

1. Got to the AWS Console, in the search box search for [**AWS CloudFormation**](https://console.aws.amazon.com/cloudformation/home) and click on that service.

2. You'll see a stack named **pcluster-manager**, click on that stack > **Outputs** Tab then click on the **PclusterManagerUrl** to connect.

![Pcluster Manager Deployed](/images/deploy-pcm/pcluster-deployed.png)

3. During deployment you received an email titled **[PclusterManager] Welcome to Pcluster Manager, please verify your account.**. Copy the password from that email.

![Pcluster Manager](/images/deploy-pcm/pcm-email.png)

4. **Enter the credentials**  using the *email* you used when deploying the stack and the *temporary password* from the email above.

![Pcluster Manager CloudFormation Stack](/images/deploy-pcm/pcmanager-creds.png)

4. You will be asked to provide a new password. Enter a new password to complete signup.

![Signup Screen](/images/deploy-pcm/signup.png)

Congrats! You are ready to create your HPC cluster in AWS. Let's do that in the next section.