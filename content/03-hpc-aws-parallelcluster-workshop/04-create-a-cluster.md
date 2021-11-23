+++
title = "d. Create an HPC Cluster"
date = 2019-09-18T10:46:30-04:00
weight = 50
tags = ["tutorial", "initialize", "ParallelCluster"]
+++

In the previous step you connected to **PCluster Manager**. Now we will create a cluster using the Cluster Creation Wizard:

1. **Click** on one of the two *Create Cluster* buttons.

![PCluster Manager CloudFormation Stack](/images/hpc-aws-parallelcluster-workshop/pcm-create1.png)

2. **Enter** the name of your cluster. Here we have chosen `my-cluster`, but feel free to pick your own cluster name. **Select** the *Wizard* and **Click** the *Next* button.

![PCluster Manager CloudFormation Stack](/images/hpc-aws-parallelcluster-workshop/pcm-create2.png)

3. **Select** the region to be *us-east-1*, and **select** a VPC.

![PCluster Manager CloudFormation Stack](/images/hpc-aws-parallelcluster-workshop/pcm-create3.png)

3. On the next screen modify the follow values:

* **Set** the *Head Node Instance Type* to be `c5.large`
* **Set** a *Subnet ID* (any will do, we will verify later)
* **Set** the *Keypair* to `ee-default-keypair` if running the lab at an AWS Hosted event.
* The *Root Volume Size* should be set to **35**

Once done, **enable** the *Virtual Console* as shown below and **click** on the *Next* button.

![PCluster Manager CloudFormation Stack](/images/hpc-aws-parallelcluster-workshop/pcm-create4.png)

4. On the storage page of the Wizard, do not change the defaults and **click** on *Next*.

5. When you reach the Queues page:

* Select a *Subnet ID* (any will do).
* Select **On-Demand** for the *Purchase Type* if not already selected.
* Then, set the field *Static Nodes* to **0** and *Dynamic Nodes* to **10**. This means that when your cluster launches it will have 0 compute nodes but that it can scale up to as many as 10 instances when jobs are submitted.
* For the *Instance Type*, select **c5.xlarge** (you can use the search field to make it easier to find this instance type).

Finish by **clicking** on the *Next* button.

![PCluster Manager CloudFormation Stack](/images/hpc-aws-parallelcluster-workshop/pcm-create6.png)

6. The last Wizard page provides an overview of the configuration file that ParallelCluster will use to deploy your cluster. Your configuration file should look similar to the image below. **Click** on *Dry Run* to perform a validation of your configuration. Once your configuration has been validated, you can **Click** on *Create* to initiate creation of your HPC cluster.

![PCluster Manager CloudFormation Stack](/images/hpc-aws-parallelcluster-workshop/pcm-create7.png)

{{%notice note%}}
If you see the following error, go back to the subnet selection (both head and compute) and select a subnet in one of the supported **Availibility Zones**.
![PCluster Manager CloudFormation Stack](/images/hpc-aws-parallelcluster-workshop/subnet-az-issue.png)
{{% /notice %}}

It'll take about 5 to 7 minutes to create all of the required resources for your cluster. You can check the *Stack Events* tab in PCluster Manager to see the progress of your cluster creation. You can also connect to your AWS account sandbox and go to the [AWS CloudFormation](https://console.aws.amazon.com/cloudformation/home) page. Once your cluster is created, you can move on to the next section.

![PCluster Manager CloudFormation Stack](/images/hpc-aws-parallelcluster-workshop/pcm-create8.png)
