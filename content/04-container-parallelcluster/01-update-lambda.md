+++
title = "a. Update Lambda Permissions"
date = 2019-09-18T10:46:30-04:00
weight = 20
tags = ["tutorial", "update", "ParallelCluster"]
+++

Before we get started we need to add more permissions to **pcluster-manager**.

#### Modify the Lambda Function

1. Go to the [Lambda Console (deeplink)](https://eu-west-1.console.aws.amazon.com/lambda/home?region=eu-west-1#/functions?f0=true&fo=and&k0=functionName&n0=false&o0=%3A&op=and&v0=ParallelClusterFunction) and search for `ParallelClusterFunction`
2. Select the function then `Configuration` > `Permissions` > Click on the role under `Role name`.

![Attach Policies](/images/container-pc/lambda-permissions.jpeg)

3. Select the `AWSXRayDaemonWriteAccess` policy and remove it
4. Select `Add permissions` > `Attach policies`

![Attach Policies](/images/container-pc/attach-policies.jpeg)

5. Search for `AdministratorAccess` > click `Attach policies`

![Attach Policies](/images/container-pc/attach-admin.png)