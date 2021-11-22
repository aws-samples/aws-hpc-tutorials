---
title: "a. Create a Cluster"
weight: 21
tags: ["tutorial", "cloud9", "ParallelCluster"]
---

1. Click **Create Cluster** Button

2. Name the cluster **weather** and select **Template**

![Cluster Wizard](/images/wrf/pcmanager-1.png)

On the next step you'll be prompted to provide a file, download the template linked below and select that when prompted:

## [Download Template](/template/cluster-config.yaml) 

On the next few screens, we'll modify the account specific components and leave the rest as specified by the template.

3. Select a **VPC** from your account

![Cluster Wizard](/images/wrf/pcmanager-2.png)

4. Select a **Subnet** and **Keypair** from your account

![Cluster Wizard](/images/wrf/pcmanager-3.png)

4. Select the same **Subnet** from the previous step

![Cluster Wizard](/images/wrf/pcmanager-4.png)

5. Click **Dry Run** to confirm the setup and then click **Create**

![Cluster Wizard](/images/wrf/pcmanager-5.png)