+++
title = "d. Create an HPC Cluster"
date = 2019-09-18T10:46:30-04:00
weight = 40
tags = ["tutorial", "initialize", "ParallelCluster"]
+++

In the previous step you connected to **PCluster Manager**. Now we will create a cluster using the Cluster Creation Wizard:

1. **Click** on one of the two *Create Cluster* buttons.

![PCluster Manager CloudFormation Stack](/images/isc22/pcm-create1.png)

2. **Enter** the name of your cluster. Here we have chosen `my-cluster`, but feel free to pick your own cluster name. **Select** the *Wizard* and **Click** the *Next* button.

![PCluster Manager CloudFormation Stack](/images/isc22/pcm-create2.png)

3. modify the following values, as shown in the screenshot
* **Select** the region to be *eu-west-1*, 
* **select** a VPC (there should be only one available).
* **select** enable the use of "Custom AMI" and specify the following `ami-0c560ae3e9b26abfc`.


![PCluster Manager CloudFormation Stack](/images/isc22/pcm-create-3.png)

4. On the next screen modify the follow values: 

* **Set** the *Head Node Instance Type* to be `c5.large`
* **Set** a *Subnet ID* (any will do, we will verify later)
* **Set** the *Keypair* to `ee-default-keypair` if running the lab at an AWS Hosted event.
* **Set** the *Root Volume Size* to **35**.

Once done, **enable** the *Virtual Console* as shown below and **click** on the *Next* button.

![PCluster Manager CloudFormation Stack](/images/isc22/pcm-create-4.png)

5. On the storage page of the Wizard, do not change the defaults and **click** on *Next*.

6. When you reach the Queues page:

* We suggest select the same *Subnet ID* as the headnode (but any would work).
* Select **On-Demand** for the *Purchase Type* if not already selected.
* Then, set the field *Static Nodes* to **0** and *Dynamic Nodes* to **3**. This means that when your cluster launches it will have 0 compute nodes but that it can scale up to as many as 3 instances when jobs are submitted.
* For the *Instance Type*, select **c5n.18xlarge** (you can use the search field to make it easier to find this instance type).
* Enable **Placement Groups**

Finish by **clicking** on the *Next* button.

![PCluster Manager CloudFormation Stack](/images/isc22/pcm-create-5.png)

7. The last Wizard page provides an overview of the configuration file that ParallelCluster will use to deploy your cluster. Your configuration file should look similar to the image below. **Click** on *Dry Run* to perform a validation of your configuration. Once your configuration has been validated, you can **Click** on *Create* to initiate creation of your HPC cluster.

![PCluster Manager CloudFormation Stack](/images/isc22/pcm-create-6.png)

{{%notice note%}}
If you see the following error, go back to the subnet selection (both head and compute) and select a subnet in one of the supported **Availibility Zones**.
![PCluster Manager CloudFormation Stack](/images/isc22/subnet-az-issue.png)
{{% /notice %}}

It'll take ~10 minutes to create all of the required resources for your cluster. You can check the *Stack Events* tab in PCluster Manager to see the progress of your cluster creation. You can also connect to your AWS account sandbox and go to the [AWS CloudFormation](https://console.aws.amazon.com/cloudformation/home) page. Once your cluster is created, you can move on to the next section.

![PCluster Manager CloudFormation Stack](/images/isc22/pcm-create-7.png)

Green checkbox will apper when the cluster creation completes successfully

![PCluster Manager CloudFormation Stack](/images/isc22/pcm-create-8.png)