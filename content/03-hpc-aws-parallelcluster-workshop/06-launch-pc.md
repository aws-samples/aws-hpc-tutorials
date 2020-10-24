+++
title = "d. Build an HPC Cluster"
date = 2019-09-18T10:46:30-04:00
weight = 70
tags = ["tutorial", "create", "ParallelCluster"]
+++

In this section, you create a cluster based on the specifications defined in the configuration file. To create a cluster, you use the command [**pcluster create**](https://docs.aws.amazon.com/parallelcluster/latest/ug/pluster.create.html) and the [**--config**](https://docs.aws.amazon.com/parallelcluster/latest/ug/pluster.create.html#pluster.create.namedarg) (or **-c**) option to use another configuration file other than the default one.

{{% notice tip %}}
If you create your cluster without using the**--config** (or **-c**) option, then AWS ParallelCluster uses the default configuration with the minimum requirements to get a cluster running. For example, the default configuration for head and compute nodes is *t2.micro* instances instead of *c5.xlarge*.
{{% /notice %}}


In your AWS Cloud9 terminal, run the following to create a cluster. Make sure that the configuration file path is correct.

```bash
pcluster create hpclab-yourname -c my-cluster-config.ini
```

Your cluster will take a few minutes to build. The creation status displays in your terminal. Once the cluster is ready, you should see a result similar to the one shown in the following image.

![ParallelCluster creation output](/images/hpc-aws-parallelcluster-workshop/pc-create-output-new.png)


{{% notice tip %}}
There can be only one cluster of a given name at any time on your account.
{{% /notice %}}


#### What's Happening in the Background

When the **pcluster create** command is executed, AWS ParallelCluster generates an [AWS CloudFormation](https://aws.amazon.com/cloudformation/) template to generate an infrastructure in AWS. The bulk of the work is done in AWS and once the create is launched, you don't need to keep AWS ParallelCluster running. If you want to see AWS CloudFormation generating the infrastructure, you can view the [CloudFormation console](https://console.aws.amazon.com/cloudformation/). The following image shows cluster creation in the CloudFormation console.

![ParallelCluster CloudFormation](/images/hpc-aws-parallelcluster-workshop/pc-cloudformation.png)
