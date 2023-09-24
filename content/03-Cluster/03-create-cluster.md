---
title: "b. Create Cluster"
weight: 33
tags: ["tutorial", "cloud9", "ParallelCluster"]
---

In this section we'll verify the cluster configuration we just created with the **Dry run** feature, then **Create** the cluster.

1. Next modify the `InstanceType` section to make sure it's specified as `InstanceType` instead of `InstanceType` in a list.

    ```yaml
    # change
    Instances:
      - InstanceType: p4d.24lxarge
    # to
    InstanceType: p4d.24lxarge
    ```

    ![Modify Instance Type](/images/03-cluster/pcui-6.png)

2. Next, click **Dry Run** to confirm the setup and then click **Create**

    ![Create Cluster](/images/03-cluster/pcui-7.png)

You'll see the stack events as the cluster creates. This will take up to **15 minutes** so in the meantime grab a ☕️ or 🍺.