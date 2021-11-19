+++
title = "c. Connect to Pcluster Manager (Post-Event)"
date = 2019-09-18T10:46:30-04:00
weight = 50
tags = ["tutorial", "initialize", "ParallelCluster"]
+++

{{% notice warning %}}
Skip this step if you are doing the labs during the re:Invent workshop.
{{% /notice %}}

1. Got to the AWS Console, in the search box search for [**AWS CloudFormation**](https://console.aws.amazon.com/cloudformation/home) and click on that service.

2. **Click** on the *pcluster-manager* stack, **select** the *Outputs* tab and **click** on the link with the key `PclusterManagerUrl`.

![Pcluster Manager CloudFormation Stack](/images/hpc-aws-parallelcluster-workshop/pcmanager-url.png)

3. During deployment you received an email titled **[PclusterManager] Welcome to Pcluster Manager, please verify your account.**. Copy the password from that email.

![Pcluster Manager](/images/hpc-aws-parallelcluster-workshop/pcm-email.png)

4. **Enter the credentials**  using the *email* you used when deploying the stack and the *temporary password* from the email above.

![Pcluster Manager CloudFormation Stack](/images/hpc-aws-parallelcluster-workshop/pcmanager-creds.png)

4. You will be asked to provide a new password. Enter a new password to complete signup.

Congrats! You are ready to create your HPC cluster in AWS. Let's do that in the next page.