+++
title = "c. Apply the policy to your cluster"
date = 2019-09-18T10:46:30-04:00
weight = 100
tags = ["tutorial", "serverless", "ParallelCluster", "IAM"]
+++

{{% notice info %}}AWS ParallelCluster is an open source cluster management tool to deploy and manage HPC clusters with AWS. If you have not created a cluster, complete the [**Create an HPC Cluster**](/03-hpc-aws-parallelcluster-workshop.html) section of the workshop before proceeding further
{{% /notice %}}

Now that we have deployed a policy to enable our instances to register with AWS Systems Manager (SSM), we need to attach this policy to our instances. Let's start by reusing the the cluster you created during the previous lab. The first step will be to modify the the AWS ParallelCluster config file created earlier to add one setting, then we will reuse this config to update our existing cluster.

1. We begin by querying the Amazon Resource Name (ARN) of our newly created policy. This a unique name for each resources residing on your account that can be used as a reference. In our case, the ARN is what we will use to reference the policy in the cluster config.

   ```bash
   aws iam list-policies --query 'Policies[?PolicyName==`pclusterSSM`].Arn' --output text
   ```
 <!-- - Add a line `additional_iam_policies=<policy-arn>` to the [cluster default] section of the config file.
 - The ARN (Amazon Resource Name) for the Policy (**policy-arn**) can be obtained using the AWS CLI as shown below -->
2. Modify the AWS ParallelCluster configuration file created in the previous lab and add the line `additional_iam_policies` in the cluster section of the config file, don't forget to set the ARN of the new IAM as a parameter (just replace `AddThePolicyArnFromCLICommand` here)

   ```toml
   [aws]
   # your AWS region is already set here

   [global]
   # global config lines

   [cluster default]
   #...
   # your cluster section lines
   # just add the new line below
   additional_iam_policies=AddThePolicyArnFromCLICommand

   [queue ondemand]
   # queue config

   [compute_resource ondemand_c5_l]
   # queue resources config

   [vpc public]
   # your vpc config

   [ebs myebs]
   # ebs config

   [aliases]
   # aliases config
   ```
   {{%expand "Quick shortcut to help you (click to expand)" %}}
   To generate the full line to add in your config file just run this command and copy it to the cluster section
   ```
   echo "additional_iam_policies=$(aws iam list-policies --query 'Policies[?PolicyName==`pclusterSSM`].Arn' --output text)"
   ```
   {{% /expand%}}

3. Update your existing cluster and apply the new policy by running the command below in your Cloud9 terminal.

   ```bash
   pcluster update <your-cluster-name> -c <your-cluster-config>.ini
   ```

Now we should be done with the preparatory work. In the next section, we will enter the realm of serverless functions.


{{% notice tip %}}
To learn more about the AWS ParallelCluster Update Policies see [here](https://docs.aws.amazon.com/parallelcluster/latest/ug/using-pcluster-update.html)
{{% /notice %}}

{{% notice info %}}
For adding new IAM policies in AWS ParallelCluster it is recommended to use **additional_iam_policies** option instead of the **ec2_iam_role**. This is because **additional_iam_policies** are added (appended) to the permissions that AWS ParallelCluster requires, and the **ec2_iam_role** must include [all permissions](https://docs.aws.amazon.com/parallelcluster/latest/ug/iam.html) required for cluster to be created. Typically this last point is used in advanced setups.
{{% /notice %}}
