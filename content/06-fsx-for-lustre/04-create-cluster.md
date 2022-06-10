+++
title = "d. Create HPC Cluster"
date = 2019-09-18T10:46:30-04:00
weight = 40
tags = ["configuration", "FSx", "ParallelCluster"]
+++

#### Create HPC Cluster

In this section we're going to use PCluster Manager to create a cluster and mount the filesystem.

1. Click **Create Cluster** Button

2. Name the cluster **hpc-cluster** and select **Template**. On the next step you'll be prompted to provide a file, download the template linked below and select that when prompted:

{{% button href="/template/cluster-config.yml" icon="fas fa-save" %}}Download Template{{% /button %}}

![Cluster Wizard](/images/pcluster/pcmanager-1.png)

On the next few screens, we'll modify the account specific components and leave the rest as specified by the template.

3. Select a **VPC** from your account

![Cluster Wizard](/images/pcluster/pcmanager-2.png)

4. Select a **Subnet**, ensuring the subnet is from the Availibility Zone ID **use2-az2**, and select a **Keypair** from your account (optional)

![Cluster Wizard](/images/pcluster/pcmanager-3.png)

5. On the **Storage** tab, select **Amazon FSx for Lustre (FSX)** from the drop down and enable **Use Existing Filesystem**. Select **hpcworkshops** filesystem from the drop down.

![Cluster Wizard](/images/pcluster/pcmanager-6.png)

5. Select the same **Subnet** from the previous step

![Cluster Wizard](/images/pcluster/pcmanager-4.png)

5. Click **Dry Run** to confirm the setup and then click **Create**

![Cluster Wizard](/images/pcluster/pcmanager-5.png)