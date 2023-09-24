---
title: "b. Capacity Reservation"
weight: 32
tags: ["tutorial", "cloud9", "ParallelCluster"]
---

![EC2 Instance](/images/03-cluster/ec2.png)

On-Demand Capacity Reservation (ODCR) is a tool for reserving capacity without having to launch and run the instances. For capacity constrained instances like the `p4d.24xlarge`, this is typically **the only way** to launch them.

In this section we'll show you how to either:

* [Create ODCR](#create_odcr) **OR**
* [Accept ODCR](#accept_odcr) that's been created for you

Then once you've got capacity we'll:

* [Modify Config](#modify_config) to include your ODCR **OR**
* [Add a group](#capacity_group) of ODCR's to your cluster

1. Navigate to the [EC2 Capacity Reservations Console](https://console.aws.amazon.com/ec2/home?#CapacityReservations:). If you already have a capacity reservation, skip to [Accept ODCR](#accept_odcr), otherwise [Create ODCR](#create_odcr).

## Create ODCR {#create_odcr}

1. From the [EC2 Capacity Reservations Console](https://console.aws.amazon.com/ec2/home?#CapacityReservations:) click **Create**
2. On the next screen enter `p4d.24xlarge` as the instance type and enter the same Availibility Zone (AZ) as you setup [previously](/01-getting-started/03-vpc-deployment.html)

    ![Create ODCR](/images/03-cluster/odcr.jpeg)

3. Leave the rest as default and click **Create**.
4. Copy the ODCR ID and proceed to [Modify Cluster Config](#modify_config)

## Accept ODCR {#accept_odcr}

If AWS creates a Capacity Reservation for you, you'll need to accept it. 

{{% notice note %}}
Once you accept the capacity reservation, then billing will start. Hence we recommend only accepting the capacity once you're ready to build the cluster.
{{% /notice %}}

1. On the [EC2 Capacity Reservations Console](https://console.aws.amazon.com/ec2/home?#CapacityReservations:) you'll see a pending capacity reservation, click **Accept**.

2. That's it, copy the id and proceed to [Modify Cluster Config](#modify_config)

## Modify Cluster Config {#modify_config}

1. AWS ParallelCluster supports specifying the [CapacityReservationId](https://docs.aws.amazon.com/parallelcluster/latest/ug/Scheduling-v3.html#yaml-Scheduling-SlurmQueues-CapacityReservationTarget) in the cluster's config file. On the **Review** screen, edit the cluster's yaml and include (at the same indent level as **Name: compute**) the following:

    ```yaml
    CapacityReservationTarget:
        CapacityReservationId: cr-061fcf9b1b320a075
    ```

    ![Include ODCR](/images/03-cluster/pcui-5.png)

## Capacity Reservation Group {#capacity_group}

If you have multiple ODCR's you can group them together into a [*Capacity Reservation Group*](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/create-cr-group.html), this allows you to launch instances from multiple ODCR's as part of the **same queue** of the cluster.

1. First create a group, this will return a group arn like: `arn:aws:resource-groups:us-east-2:822857487308:group/MyCRGroup`. Save that for later.

    ```bash
    $ aws resource-groups create-group --name MyCRGroup --configuration '{"Type":"AWS::EC2::CapacityReservationPool"}' '{"Type":"AWS::ResourceGroups::Generic", "Parameters": [{"Name": "allowed-resource-types", "Values": ["AWS::EC2::CapacityReservation"]}]}'
    ```

2. Next add your capacity reservations to that group:

    ```bash
    aws resource-groups group-resources --group MyCRGroup --resource-arns arn:aws:ec2:sa-east-1:123456789012:capacity-reservation/cr-1234567890abcdef1 arn:aws:ec2:sa-east-1:123456789012:capacity-reservation/cr-54321abcdef567890
    ```

3. Then add the group to your cluster's config like so:

    ```yaml
        CapacityReservationTarget:
            CapacityReservationResourceGroupArn: arn:aws:resource-groups:us-east-2:123456789012:group/MyCRGroup
    ```