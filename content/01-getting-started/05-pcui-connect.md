+++
title = "d. Connect to ParallelCluster UI"
weight = 15
tags = ["tutorial", "cloud9", "ParallelCluster"]
+++

1. Got to the AWS Console, in the search box search for [**AWS CloudFormation**](https://console.aws.amazon.com/cloudformation/home) and click on that service.

2. You'll see a stack named **parallelcluster-ui**, click on that stack > **Outputs** Tab then click on the **ParallelClusterUIUrl** to connect.

![ParallelCluster UI Deployed](/images/01-getting-started/pcluster-deployed.png)

3. During deployment you received an email titled **[ParallelClusterUI] Welcome to ParallelCluster UI, please verify your account.**. Copy the password from that email.

![ParallelCluster UI](/images/01-getting-started/pcm-email.png)

4. **Enter the credentials**  using the *email* you used when deploying the stack and the *temporary password* from the email above.

![ParallelCluster UI CloudFormation Stack](/images/01-getting-started/pcmanager-creds.png)

4. You will be asked to provide a new password. Enter a new password to complete signup.

![Signup Screen](/images/01-getting-started/signup.png)

Congrats! You are ready to create your HPC cluster in AWS. Let's do that in the next section.