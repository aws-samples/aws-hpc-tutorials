+++
title = "e. Add IAM Permissions"
weight = 16
tags = ["tutorial", "ParallelCluster"]
+++

## Add permissions to your lambda

In order to create our cluster we need to add an additional IAM policy.

1. Go to the [Lambda Console (deeplink)](https://console.aws.amazon.com/lambda/home?#/functions?f0=true&fo=and&k0=functionName&n0=false&o0=%3A&op=and&v0=ParallelClusterFunction) and search for `ParallelClusterFunction`

2. Select the function then `Configuration` > `Permissions` > Click on the role under `Role name`.

    ![Attach Policies](/images/01-getting-started/lambda-permissions.jpeg)

3. Select the `AWSXRayDaemonWriteAccess` policy and remove it

4. Select `Add permissions` > `Attach policies`

    ![Attach Policies](/images/01-getting-started/attach-policies.jpeg)

5. Search for `AdministratorAccess` > click `Attach policies`

    ![Attach Policies](/images/01-getting-started/attach-admin.png)