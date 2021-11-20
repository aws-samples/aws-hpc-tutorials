+++
title = "c. Connect to Pcluster Manager (Post-Event)"
date = 2019-09-18T10:46:30-04:00
weight = 50
tags = ["tutorial", "initialize", "ParallelCluster"]
+++

{{% notice warning %}}
You should skip this step if you are participating in the re:Invent workshop.
{{% /notice %}}

- Go to the AWS Console, and in the search box search for [**AWS CloudFormation**](https://console.aws.amazon.com/cloudformation/home) and click on that service.

- Click on the *pcluster-manager* stack, select the *Outputs* tab and click on the link with the key `PclusterManagerUrl`.

![Pcluster Manager CloudFormation Stack](/images/hpc-aws-parallelcluster-workshop/pcmanager-url.png)

- During deployment you received an email titled **[PclusterManager] Welcome to Pcluster Manager, please verify your account.**. Copy the password from that email.

![Pcluster Manager](/images/hpc-aws-parallelcluster-workshop/pcm-email.png)

- **Enter the credentials**  using the *email* you used when deploying the stack and the *temporary password* from the email above.

![Pcluster Manager CloudFormation Stack](/images/hpc-aws-parallelcluster-workshop/pcmanager-creds.png)

- You will be asked to provide a new password. Enter a new password to complete signup.

Congrats! You are ready to create your HPC cluster in AWS. Continue to the next page to proceed with cluster creation.