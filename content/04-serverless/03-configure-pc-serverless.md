+++
title = "c. Apply the policy to your cluster"
date = 2019-09-18T10:46:30-04:00
weight = 100
tags = ["tutorial", "serverless", "ParallelCluster", "IAM"]
+++

{{% notice info %}}AWS ParallelCluster is an open-source cluster management tool you can use to deploy and manage HPC clusters in AWS. If you have not created a cluster, complete the section [**Create an HPC Cluster**](/03-hpc-aws-parallelcluster-workshop.html) before proceeding further
{{% /notice %}}

Now that you have deployed a custom IAM policy to enable your instances to register with AWS Systems Manager (SSM), you need to attach this policy to your instances. Let's start by reusing the cluster you created during the previous lab. The first step will be to modify the the AWS ParallelCluster config file created earlier to add one setting, then you will reuse this configuraton file to update your existing cluster.

1. Begin by querying the Amazon Resource Name (ARN) of your newly created policy. This a unique name for each resources residing on your account that can be used as a reference. In this lab, the ARN is what you will use to reference the IAM policy in the cluster configuration file.

   ```bash
   CLUSTER_IAM_POLICY=`aws iam list-policies --query 'Policies[?PolicyName==\`pclusterSSM\`].Arn' --output text`
   echo $CLUSTER_IAM_POLICY
   ```

2. Modify the AWS ParallelCluster configuration file `my-cluster-config.ini` created in the previous lab, it should be located in `~/environment`. Then add the line `additional_iam_policies` in the cluster section of the config file, don't forget to set the ARN of the new IAM as a parameter (just replace `AddThePolicyArnFromCLICommand` here). To ease the configuration file editing, you will download and use a python utility named **crudini**.

   ```bash
   #Clont crudini repository
   git clone https://github.com/pixelb/crudini
   #Install dependencies
   sudo pip install iniparse

   #Change the cluster configuration file
   crudini/crudini --set ~/environment/my-cluster-config.ini "cluster default" additional_iam_policies "$CLUSTER_IAM_POLICY" 
   ```

3. Update your existing cluster and apply the new policy by running the command below in your Cloud9 terminal.

   ```bash
   pcluster update <your-cluster-name> -c <your-cluster-config>.ini
   ```

Now you should be done with the preparatory work. In the next section, you will enter the realm of serverless functions.


{{% notice tip %}}
To learn more about the AWS ParallelCluster Update Policies see [here](https://docs.aws.amazon.com/parallelcluster/latest/ug/using-pcluster-update.html)
{{% /notice %}}

{{% notice info %}}
For adding new IAM policies in AWS ParallelCluster it is recommended to use `additional_iam_policies` option instead of the `ec2_iam_role`. This is because `additional_iam_policies` are added (appended) to the permissions that AWS ParallelCluster requires, and the `ec2_iam_role` must include [all permissions](https://docs.aws.amazon.com/parallelcluster/latest/ug/iam.html) required for cluster to be created. Typically this last point is used in advanced setups.
{{% /notice %}}
