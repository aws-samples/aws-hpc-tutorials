+++
title = "c. Connect to Pcluster Manager"
date = 2019-09-18T10:46:30-04:00
weight = 50
tags = ["tutorial", "initialize", "ParallelCluster"]
+++

Now that Pcluster Manager is deployed, you will connect to it and create an HPC cluster. You will start by retrieving the URL of Pcluster Manager, then login.

1. Got to the AWS Console, in the search box search for AWS CloudFormation and click on the icon. You can alternatively [**click on this link**](https://console.aws.amazon.com/cloudformation/home).
2. **Click** on the *pcluster-manager* stack, **select** the *Outputs* tab and **click** on the link with the key `PclusterManagerUrl`.

![Pcluster Manager CloudFormation Stack](/images/hpc-aws-parallelcluster-workshop/pcmanager-url.png)

3. **Enter the credentials**  using the *email* you used when deploying the stack in the preparation stage and the *temporary password* you received on this email.

![Pcluster Manager CloudFormation Stack](/images/hpc-aws-parallelcluster-workshop/pcmanager-creds.png)

4. You will be asked to provide a new password. **Enter** the password you received or use your own password (like `reInvent21!`).

5. Once the new password provided you will land on the page shown below.

![Pcluster Manager CloudFormation Stack](/images/hpc-aws-parallelcluster-workshop/pcmanager-first-page.png)

Congrats! You are ready to create your HPC cluster in AWS. Let's do that in the next page.
