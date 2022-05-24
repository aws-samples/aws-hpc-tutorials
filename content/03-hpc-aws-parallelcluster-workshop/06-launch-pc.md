+++
title = "e. Build an HPC Cluster"
date = 2022-04-10T10:46:30-04:00
weight = 50
tags = ["tutorial", "create", "ParallelCluster"]
+++

In this section, you create a cluster based on the specifications defined in the configuration file. To create a cluster, you use the command **[pcluster create-cluster](https://docs.aws.amazon.com/parallelcluster/latest/ug/pcluster.create-cluster-v3.html)**.

In your AWS Cloud9 terminal, run the following to create a cluster. Make sure that the configuration file path is correct.

```bash
pcluster create-cluster --region ${AWS_REGION} --cluster-name hpc-cluster-lab --suppress-validators ALL --cluster-configuration my-cluster-config.yaml
```

The the cluster creation process will take ~10 minutes. Below is the expected output.

```bash
TeamRole:~/environment $ source env_vars
TeamRole:~/environment $ pcluster create-cluster --region ${AWS_REGION} --cluster-name hpc-cluster-lab --suppress-validators ALL --cluster-configuration my-cluster-config.yaml
{
  "cluster": {
    "clusterName": "hpc-cluster-lab",
    "cloudformationStackStatus": "CREATE_IN_PROGRESS",
    "cloudformationStackArn": "arn:aws:cloudformation:us-west-1:146043110428:stack/hpc-cluster-lab/4934f020-bca3-11ec-9752-0ecc1f64971f",
    "region": "eu-west-1",
    "version": "3.1.2",
    "clusterStatus": "CREATE_IN_PROGRESS"
  },
}
```

{{% notice tip %}}
There can be only one cluster of a given name at any time on your account.
{{% /notice %}}


#### What's Happening in the Background

When the **pcluster create-cluster** command is executed, AWS ParallelCluster generates an [AWS CloudFormation](https://aws.amazon.com/cloudformation/) template to generate an infrastructure in AWS. If you want to see AWS CloudFormation generating the infrastructure, you can view the [CloudFormation console](https://console.aws.amazon.com/cloudformation/). The following image shows cluster creation in the CloudFormation console. 

![ParallelCluster CloudFormation](/images/hpc-aws-parallelcluster-workshop/pc-cloudformation.png)

There is a visual alternative to the command line interface for deploying and managing your clusters called **pcluster-manager**. Move on to the next stage while your cluster is deploying to explore this.