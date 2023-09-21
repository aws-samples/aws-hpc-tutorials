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

4. Select `Add permissions` > `Create inline Policy`

    ![Attach Policies](/images/03-cluster/attach-policies.png)

5. Click on the **JSON** tab and paste in the following policy. Make sure to change `<account-id>` to your aws account id.

    ```
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Action": [
                "iam:AttachRolePolicy",
                "iam:DetachRolePolicy"
                ],
                "Effect": "Allow",
                "Resource": "arn:aws:iam::<account-id>:role/parallelcluster/*"
            }
        ]
    }
    ```

6. Click **Review Policy**, give it a name like `pcluster-attach-detach-policies` and click **Save**.
