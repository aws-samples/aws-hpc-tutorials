+++
title = "c. Create an HPC Cluster"
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


5. When on the Queues page, **select** a *Subnet ID*, any will. Select **On-Demand** for the *Purchase Type* if not already selected. Then, set the field *Static Nodes* to **0** and *Dynamic Nodes* to **10**. This means that your cluster will have 0 compute instances but can scale up to 10 instances when jobs are submitted. For the *Instance Type*, select **c5.xlarge**, use the search field to make your selection easier.Finish by **clicking** on the *Next* button.

![Pcluster Manager CloudFormation Stack](/images/hpc-aws-parallelcluster-workshop/pcm-create6.png)

6. The last Wizard page provides an overview of the AWS ParallelCluster configuration that will be deployed. Your configuration file will have similar fields as in the image below. **Click** on *Dry Run* to validate the configuration. If valid, the configuration will be validated. **Click** on *Create* to create your HPC cluster.

![Pcluster Manager CloudFormation Stack](/images/hpc-aws-parallelcluster-workshop/pcm-create7.png)


It'll take about 5 to 7 minutes to create the resources of your cluster. You can check the *Stack Events* tab in Pcluster Manager to see the progress of your cluster creation. You can also connect to your AWS account sandbox and go to the [AWS CloudFormation](https://console.aws.amazon.com/cloudformation/home) page. Once your cluster is created, to go the next section.

![Pcluster Manager CloudFormation Stack](/images/hpc-aws-parallelcluster-workshop/pcm-create8.png)
