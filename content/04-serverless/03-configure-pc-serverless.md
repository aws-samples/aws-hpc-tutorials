+++
title = "c. Update the cluster with custom IAM Policy"
date = 2019-09-18T10:46:30-04:00
weight = 100
tags = ["tutorial", "serverless", "ParallelCluster", "IAM"]
+++

{{% notice info %}}AWS ParallelCluster is an open source cluster management tool to deploy and manage HPC clusters in the AWS cloud. If you have not created a cluster, complete the [**Create an HPC Cluster**](/03-hpc-aws-parallelcluster-workshop.html) section of the workshop before proceeding further
{{% /notice %}}

In order to add the custom IAM policy (created in the previous section) in your cluster, the AWS ParallelCluster config file created earlier needs to be updated. There's a complete config file included below with key changes:

1. To enable additional IAM policies

 - Add a line `additional_iam_policies=<policy-arn>` to the [cluster default] section of the config file.
 - The ARN (Amazon Resource Name) for the Policy (**policy-arn**) can be obtained using the AWS CLI as shown below

   ```bash
   aws iam list-policies --query 'Policies[?PolicyName==`pclusterSSM`].Arn' --output text
   ```

{{% notice tip %}}
For adding new IAM policies in AWS ParallelCluster it is recommended to use **additional_iam_policies** option instead of the **ec2_iam_role**. This is because **additional_iam_policies** are added (appended) to the permissions that AWS ParallelCluster requires, and the **ec2_iam_role** must include all permissions required.
{{% /notice %}}


2. Modify the AWS ParallelCluster config file created earlier. Note the modified items are highlighted:

   ```toml
   [aws]
   aws_region_name = ${REGION_NAME}

   [global]
   cluster_template = default
   update_check = false
   sanity_check = true

   [cluster default]
   key_name = lab-3-your-key
   base_os = alinux2
   vpc_settings = public
   ebs_settings = myebs
   master_instance_type = c4.xlarge
   queue_settings = ondemand
   s3_read_write_resource = *
   scheduler = slurm
   additional_iam_policies=<policy-arn-from-cli-command>

   [queue ondemand]
   compute_resource_settings = ondemand_c5_l

   [compute_resource ondemand_c5_l]
   instance_type = c5.large
   min_count = 0
   max_count = 8
   initial_count = 0


   [vpc public]
   vpc_id = vpc-****
   master_subnet_id = subnet-****

   [ebs myebs]
   shared_dir = /shared
   volume_type = gp2
   volume_size = 20

   [aliases]
   ssh = ssh {CFN_USER}@{MASTER_IP} {ARGS}
   ```

3. Update the cluster. Note that you are updating your cluster with the additional IAM policy and not re-creating it

  ```bash
   pcluster update <your-cluster-name> -c <your-cluster-config>.ini
  ```


{{% notice tip %}}
To learn more about the AWS ParallelCluster Update Policies see [here](https://docs.aws.amazon.com/parallelcluster/latest/ug/using-pcluster-update.html)
{{% /notice %}}

