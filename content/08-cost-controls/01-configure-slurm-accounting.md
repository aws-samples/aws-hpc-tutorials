---
title: "a. Configure Slurm Accounting and Prerequisites"
weight: 81
---

In this section, you will modify the cluster created in Lab I to enable Slurm Accounting resource limits.

### Modify Cluster Configuration for Cost Controls

{{% notice note %}}
Make sure that you are in your Cloud9 terminal to start this lab. To access Cloud9, please refer to the instructions under *Connect to AWS Cloud9 Instance* in the **[Access Cloud9 Environment](/00-overview/03-access-cloud9)** section.
{{% /notice %}}

#### 1. Open Terminal.

Load the terminal used to maintain your AWS ParallelCluster clusters. In earlier labs, **Cloud9** was used; if following a workshop, go back to your **Cloud9 terminal**.  If you have closed the Cloud9 terminal, go back to the [Cloud9 console](https://eu-north-1.console.aws.amazon.com/cloud9control/home?region=eu-north-1#/) and re-open the terminal using the instructions found at [Access Cloud9 Environment](/00-overview/03-access-cloud9).

#### 2. Enable Resource Limits on Slurm.
The cost control solution requires that you apply a CPU minutes Resource Limit to the cluster's Slurm scheduler.
[Resource Limits](https://slurm.schedmd.com/resource_limits.html) are used in Slurm to restrict job execution after a resource (CPU, RAM, etc.) usage limit has been reached.

Run the command below to apply the `PriorityType` and `AccountingStorageEnforce` settings to the cluster configuration file. `yq` is used to automate the update of the YAML cluster configuration file.

```bash
yq -i '(.Scheduling.SlurmSettings.CustomSlurmSettings[0].PriorityType="priority/multifactor") |
      (.Scheduling.SlurmSettings.CustomSlurmSettings[1].AccountingStorageEnforce="limits")' \
      ~/environment/cluster-config.yaml
```

{{% notice note %}}
If you receive an error `bash: yq: command not found` it can be installed on the Cloud9 instance with the command `pip3 install yq`.
{{% /notice %}}

{{< detail-tag "**[Optional Information-Click here for more]**  Additional details about the Slurm customizations" >}}
The [Slurm Priority Multifactor Plugin](https://slurm.schedmd.com/priority_multifactor.html#intro) provides advanced Slurm queue management features and the Trackable Resource (TRES) scheduling factor is required to apply the GrpTRESMins limit. The [AccountingStorageEnforce](https://slurm.schedmd.com/slurm.conf.html#OPT_AccountingStorageEnforce) limits 
setting is required to enforce limits on job submissions and prevent jobs from running that have exceeded the defined resource limits.
{{< /detail-tag >}}

{{% notice note %}}
For ParallelCluster versions >= 3.6.0, you can define custom slurm.conf customizations as part of an AWS 
ParallelCluster configuration. See instructions [here](https://docs.aws.amazon.com/parallelcluster/latest/ug/slurm-configuration-settings-v3.html).
{{% /notice %}}

#### 3. Grant head node access to the [AWS Price List service](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/price-changes.html).
Run the following command to update the cluster configuration so that an additional IAM policy that grants access the AWS Price List service is applied to the head node.

```bash
yq -i '(.HeadNode.Iam.AdditionalIamPolicies[1].Policy="arn:aws:iam::aws:policy/AWSPriceListServiceFullAccess")' \
   ~/environment/cluster-config.yaml
```

{{< detail-tag "**[Optional Information-Click here for more]**  Additional details about the need for the Price List service" >}}
The cost control Python script uses the AWS Price List service to determine the per hour cost of the cluster's EC2 compute nodes.
The Python script will query the AWS Price List service using the AWS Python SDK; however, the AWS Price List service API requires
the request to contain appropriate IAM credentials to access the Price List API service.  EC2 instances can assume an IAM role, 
called an [EC2 instance profile](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-roles-for-amazon-ec2.html#ec2-instance-profile), 
so that code/processes running on the instance have access to AWS IAM credentials. 
{{< /detail-tag >}}

{{% notice note %}}
You can define additional IAM policies for both your head and compute nodes by using the "AdditionalIamPolicies" option within your ParallelCluster configuration file. See details [here](https://docs.aws.amazon.com/parallelcluster/latest/ug/iam-roles-in-parallelcluster-v3.html#iam-roles-in-parallelcluster-v3-cluster-config-additionaliampolicies)
{{% /notice %}}

### Apply Changes to Cluster

#### 1. Update the cluster.
You have modified the configuration file in the previous steps for the required changes. However, these changes won't be applied until the cluster is updated.  The `pcluster update-cluster` command below applies the changes in the configuration file to the cluster using the AWS CloudFormation service.

```bash
source ~/environment/env_vars
pcluster update-cluster -n hpc --region ${AWS_REGION} -c ~/environment/cluster-config.yaml
```

#### 2. Wait for the cluster to be updated. 
You can check the cluster update status using the `pcluster describe-cluster` command below.  

```bash
pcluster describe-cluster -n hpc --query clusterStatus --region ${AWS_REGION}
```

The cluster update will take **about 3 minutes**. You will know the cluster update is complete when you see an **UPDATE_COMPLETE** status.

You have successfully updated the cluster with the required configuration changes. In the next section, you will 
create cost controls on the cluster using Slurm Accounting and Resource Limits.