+++
title = "d. Build an HPC Cluster"
date = 2019-09-18T10:46:30-04:00
weight = 70
tags = ["tutorial", "create", "ParallelCluster"]
+++

In this section, you create a cluster based on the specifications defined in the configuration file. In your AWS Cloud9 terminal, run the following to create a cluster. Make sure that the configuration file path is correct.

```bash
pcluster create-cluster --cluster-name my-cluster --cluster-configuration my-cluster-config.yaml --region ${AWS_REGION}
```

Your cluster will take a few minutes to build. The creation status displays in your terminal. Once the cluster is ready, you should see a result similar to the one shown in the following image. Ignore the warning from *node* if you see it.

![ParallelCluster creation output](/images/hpc-aws-parallelcluster-workshop/pc-create-output-new2.png)



Run the command below to track the progress of your cluster creation:

```bash
watch -n 5 pcluster list-clusters
````

{{% notice tip %}}
There can be only one cluster of a given name at any time on your account.
{{% /notice %}}

#### What's Happening in the Background

When the **pcluster create-cluster** command is executed, AWS ParallelCluster generates an [AWS CloudFormation](https://aws.amazon.com/cloudformation/) template to generate an infrastructure in AWS. The bulk of the work is done in AWS and once the create is launched, you don't need to keep AWS ParallelCluster running. If you want to see AWS CloudFormation generating the infrastructure, you can view the [CloudFormation console](https://console.aws.amazon.com/cloudformation/). The following image shows cluster creation in the CloudFormation console.

![ParallelCluster CloudFormation](/images/hpc-aws-parallelcluster-workshop/pc-cloudformation2.png)
