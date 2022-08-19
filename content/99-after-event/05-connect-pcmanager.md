+++
title = "b. [Post-event] Connect to PCluster Manager "
date = 2019-09-18T10:46:30-04:00
weight = 40
tags = ["tutorial", "initialize", "ParallelCluster"]
+++

{{% notice note %}}
You can skip this step if you are following this workshop as part of a conference. If using Event Engine then your PCluster Manager is already deployed
{{% /notice %}}


1. Go to the AWS Console, and in the search box search for [AWS CloudFormation](https://console.aws.amazon.com/cloudformation/home) and click on that service.

2. **Click** on the *pcluster-manager* stack, **select** the *Outputs* tab and **click** on the link with the key `PClusterManagerUrl`.

![PCluster Manager CloudFormation Stack](/images/hpc-aws-parallelcluster-workshop/pcmanager-url.png)

3. During deployment you received an email titled **[PClusterManager] Welcome to PCluster Manager, please verify your account.**. Copy the password from that email.

![PCluster Manager](/images/hpc-aws-parallelcluster-workshop/pcm-email.png)

4. **Enter the credentials**  using the *email* you used when deploying the stack and the *temporary password* from the email above.

![PCluster Manager CloudFormation Stack](/images/hpc-aws-parallelcluster-workshop/pcmanager-creds.png)

4. You will be asked to provide a new password. Enter a new password to complete signup.

Congrats! You are ready to create your HPC cluster in AWS. Continue to the next page to proceed with cluster creation.
