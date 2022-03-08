+++
title = "d. Build an HPC Cluster"
date = 2019-09-18T10:46:30-04:00
weight = 70
tags = ["tutorial", "create", "ParallelCluster"]
+++

In this section, you create a cluster based on the specifications defined in the configuration file. To create a cluster, you use the command **pcluster create-cluster** (details [here](https://docs.aws.amazon.com/parallelcluster/latest/ug/pcluster.create-cluster-v3.html)) and the **--cluster-configuration** (or **-c**) option for specifying the cluster configuration file.

In your AWS Cloud9 terminal, run the following to create a cluster. Make sure that the configuration file path is correct.

```bash
pcluster create-cluster --cluster-name hpc --cluster-configuration config.yaml
```

Your cluster will take a few minutes to build. The following status message will be printed to the terminal window.

```bash
{
  "cluster": {
    "clusterName": "hpc",
    "cloudformationStackStatus": "CREATE_IN_PROGRESS",
    "cloudformationStackArn": "arn:aws:cloudformation:eu-west-1:03xxxxxxx:stack/cfd/67df3d40-4797-11ec-8758-0aef8dbeecd5",
    "region": "eu-west-1",
    "version": "3.1.2",
    "clusterStatus": "CREATE_IN_PROGRESS"
  },
}
```
During the launch process, you can check on the status of the cluster using the **pcluster list-clusters** command.

{{% notice tip %}}
There can be only one cluster of a given name at any time in your account.
{{% /notice %}}


#### What's Happening in the Background

When the **pcluster create-cluster** command is executed, AWS ParallelCluster generates an [AWS CloudFormation](https://aws.amazon.com/cloudformation/) template to generate an infrastructure in AWS. The bulk of the work is done in AWS and once the create is launched, you don't need to keep AWS ParallelCluster running. If you want to see AWS CloudFormation generating the infrastructure, you can view the [CloudFormation console](https://console.aws.amazon.com/cloudformation/). The following image shows cluster creation in the CloudFormation console.

![ParallelCluster CloudFormation](/images/hpc-aws-parallelcluster-workshop/pc-cloudformation.png)
