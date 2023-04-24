---
title: "a. Create a Cluster"
weight: 31
tags: ["tutorial", "cloud9", "ParallelCluster"]
---

![p4d Instance](/images/03-cluster/p4d.png)

In this section we're going to use ParallelCluster UI to create a cluster from a sample template we've provided.

We'll be using the [p4d.24xlarge](https://aws.amazon.com/ec2/instance-types/p4/) instance, an NVIDIA A100 based instance that comes in two variants:

| Instance Size | Cores | Memory (GiB) | GPU-A100 | GPU memory         | GPUDirect RDMA |  GPU Peer to Peer | On-demand Price/hr | Cluster Config         |
|---------------|-------|--------------|----------|--------------------|----------------|:-----------------:|--------------------|------------------------|
| p4d.24xlarge  | 96    | 1152         | 8        | 320 GB HBM2        | Yes            | 600 GB/s NVSwitch | $32.77             | {{% button href="/template/cluster-config-p4d.yaml" icon="fas fa-download" %}}Download Template{{% /button %}} |
| p4de.24xlarge | 96    | 1152         | 8        | 640 GB HBM2        | Yes            | 600 GB/s NVSwitch | $40.96             | {{% button href="/template/cluster-config-p4de.yaml" icon="fas fa-download" %}}Download Template{{% /button %}} |

1. Click **Create Cluster** Button

2. Name the cluster **p4d-cluster** and select **Template**. On the next step you'll be prompted to provide a file, download the template linked in the table above and select the template when prompted:

    ![Cluster Wizard](/images/03-cluster/pcmanager-1.png)

    On the next few screens, we'll modify the account specific components and leave the rest as specified by the template.

3. On the next page Select **VPC** and **AMI** like so:
    * Select the **VPC**, `LargeScaleVPC` created in **[b. Create VPC](01-getting-started/03-vpc-deployment.md)**
    * Select the **AMI** created in [Step 2](02-custom-ami/01-custom-ami.html)
    ![Cluster Wizard](/images/03-cluster/pcmanager-2.png)

4. Select the public **Subnet** and select a **Keypair** from your account (optional)

    ![Cluster Wizard](/images/03-cluster/pcmanager-3.png)

5. Keep the defaults on the storage tab and click Next
6. Select the **Private Subnet**

    ![Cluster Wizard](/images/03-cluster/pcmanager-4.png)

7. Proceed to the [next page](/03-cluster/02-odcr.html) to configure your Capacity Reservation.