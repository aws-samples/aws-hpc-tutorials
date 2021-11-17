+++
title = "c. Install the AWS ParallelCluster API"
date = 2019-09-18T10:46:30-04:00
weight = 50
tags = ["tutorial", "initialize", "ParallelCluster"]
+++

In the previous steps you have created the Pcluster Manager stack and connected to Pcluster Manager. You will now create a cluster using the Cluster Creation Wizard of Pcluster Manager. We will run through all stages progressively.

1. **Click** on one of the two *Create Cluster* button.

![Pcluster Manager CloudFormation Stack](/images/hpc-aws-parallelcluster-workshop/pcm-create1.png)

2. **Enter** the name of your cluster, we chose `my-cluster` but feel free to pick your own cluster name. **Select** the *Wizard* and **Click** the *Next* button.

![Pcluster Manager CloudFormation Stack](/images/hpc-aws-parallelcluster-workshop/pcm-create2.png)

3. **Select** the region to be *us-east-1*, and **select** your default VPC.

![Pcluster Manager CloudFormation Stack](/images/hpc-aws-parallelcluster-workshop/pcm-create3.png)


3. **Select** the *Head Node Instance Type* to be `c5.large`, then pick a *Subnet ID*. Then, **select** a *Keypair*. One is created with your temporary account on Event Engine, use that one. Once done, **enable** the *Virtual Console* as shown below and **click** on the *Next* button.

![Pcluster Manager CloudFormation Stack](/images/hpc-aws-parallelcluster-workshop/pcm-create4.png)

4. On the storage page of the Wizard, **select** Amazon Elastic Block Store as the value for *Storage Type*. Leave the rest as default and **click** on *Next*.

![Pcluster Manager CloudFormation Stack](/images/hpc-aws-parallelcluster-workshop/pcm-create5.png)


5. On the storage page of the Wizard, **select** Amazon Elastic Block Store as the value for *Storage Type*. Leave the rest as default and **click** on *Next*.

![Pcluster Manager CloudFormation Stack](/images/hpc-aws-parallelcluster-workshop/pcm-create5.png)
