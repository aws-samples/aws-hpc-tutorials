---
title: "b. Capacity Reservation"
weight: 32
tags: ["tutorial", "cloud9", "ParallelCluster"]
---

On-Demand Capacity Reservation (ODCR) is a tool for reserving capacity without having to launch and run the instances. For capacity constrained instances like the `p4d.24xlarge`, this is typically **the only way** to launch them.

In this section we'll show you how to either:

* create an ODCR  
* accept one that's been created for you (most likely scenario)

1. Navigate to the [EC2 Capacity Reservations Console](https://console.aws.amazon.com/ec2/home?#CapacityReservations:). If you already have a capacity reservation, skip to [Accept ODCR](#accept_odcr), otherwise [Create ODCR](#create_odcr).

## Create ODCR {#create_odcr}

1. From the [EC2 Capacity Reservations Console](https://console.aws.amazon.com/ec2/home?#CapacityReservations:) click **Create**
2. On the next screen enter `p4d.24xlarge` as the instance type and enter the same Availibility Zone (AZ) as you setup [previously](/01-getting-started/03-vpc-deployment.html)

    ![Create ODCR](/images/03-cluster/odcr.jpeg)

3. Leave the rest as default and click **Create**.
4. Copy the ODCR ID and proceed to [Modify Cluster Config](#modify_config)

## Accept ODCR (most likely scenario) {#accept_odcr}

1. On the [EC2 Capacity Reservations Console](https://console.aws.amazon.com/ec2/home?#CapacityReservations:) you'll see a pending capacity reservation, click **Accept**.

2. That's it, copy the id and proceed to [Modify Cluster Config](#modify_config)

## Modify Cluster Config {#modify_config}

1. AWS ParallelCluster supports specifying the [CapacityReservationId](https://docs.aws.amazon.com/parallelcluster/latest/ug/Scheduling-v3.html#yaml-Scheduling-SlurmQueues-CapacityReservationTarget) in the cluster's config file. On the **Review** screen, edit the cluster's yaml and include (at the same indent level as **Name: compute**) the following:

    ```yaml
    CapacityReservationTarget:
        CapacityReservationId: cr-061fcf9b1b320a075
    ```

    ![Include ODCR](/images/03-cluster/include_odcr.png)

2. Next modify the `InstanceType` section to make sure it's specified as `InstanceType` instead of `InstanceType` in a list.

    ```yaml
    Instances:
      - InstanceType: p4d.24lxarge
    # to
    InstanceType: p4d.24lxarge
    ```

3. Next, click **Dry Run** to confirm the setup and then click **Create**

    ![Cluster Wizard](/images/03-cluster/pcmanager-5.png)
