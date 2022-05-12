+++
title = "e. Build an HPC Cluster"
date = 2022-04-10T10:46:30-04:00
weight = 50
tags = ["tutorial", "create", "ParallelCluster"]
+++

In this section, you create a cluster based on the specifications defined in the configuration file. To create a cluster, you use the command **[pcluster create-cluster](https://docs.aws.amazon.com/parallelcluster/latest/ug/pcluster.create-cluster-v3.html)**.

In your AWS Cloud9 terminal, run the following to create a cluster. Make sure that the configuration file path is correct.

```bash
pcluster create-cluster --region ${AWS_REGION} --cluster-name hpc-cluster-lab --cluster-configuration my-cluster-config.yaml
```

The **pcluster create-cluster** command might output a few warnings, the cluster creation will progress. 

```bash
TeamRole:~/environment $ source env_vars
TeamRole:~/environment $ pcluster create-cluster --region ${AWS_REGION} --cluster-name hpc-cluster-lab --cluster-configuration my-cluster-config.yaml
{
  "cluster": {
    "clusterName": "hpc-cluster-lab",
    "cloudformationStackStatus": "CREATE_IN_PROGRESS",
    "cloudformationStackArn": "arn:aws:cloudformation:us-east-1:146043110428:stack/hpc-cluster-lab/4934f020-bca3-11ec-9752-0ecc1f64971f",
    "region": "us-east-1",
    "version": "3.1.1",
    "clusterStatus": "CREATE_IN_PROGRESS"
  },
  "validationMessages": [
    {
      "level": "WARNING",
      "type": "CustomAmiTagValidator",
      "message": "The custom AMI may not have been created by pcluster. You can ignore this warning if the AMI is shared or copied from another pcluster AMI. If the AMI is indeed not created by pcluster, cluster creation will fail. If the cluster creation fails, please go to https://docs.aws.amazon.com/parallelcluster/latest/ug/troubleshooting.html#troubleshooting-stack-creation-failures for troubleshooting."
    },
    {
      "level": "WARNING",
      "type": "AmiOsCompatibleValidator",
      "message": "Could not check node AMI ami-0c560ae3e9b26abfc OS and cluster OS alinux2 compatibility, please make sure they are compatible before cluster creation and update operations."
    },
    {
      "level": "WARNING",
      "type": "CustomAmiTagValidator",
      "message": "The custom AMI may not have been created by pcluster. You can ignore this warning if the AMI is shared or copied from another pcluster AMI. If the AMI is indeed not created by pcluster, cluster creation will fail. If the cluster creation fails, please go to https://docs.aws.amazon.com/parallelcluster/latest/ug/troubleshooting.html#troubleshooting-stack-creation-failures for troubleshooting."
    },
    {
      "level": "WARNING",
      "type": "DcvValidator",
      "message": "With this configuration you are opening DCV port 8443 to the world (0.0.0.0/0). It is recommended to restrict access."
    },
    {
      "level": "WARNING",
      "type": "AmiOsCompatibleValidator",
      "message": "Could not check node AMI ami-0c560ae3e9b26abfc OS and cluster OS alinux2 compatibility, please make sure they are compatible before cluster creation and update operations."
    }
  ]
}
```


Your cluster will take ~10 minutes to build.

{{% notice tip %}}
There can be only one cluster of a given name at any time on your account.
{{% /notice %}}


#### What's Happening in the Background

When the **pcluster create-cluster** command is executed, AWS ParallelCluster generates an [AWS CloudFormation](https://aws.amazon.com/cloudformation/) template to generate an infrastructure in AWS. The bulk of the work is done in AWS and once the create is launched, you don't need to keep AWS ParallelCluster running. If you want to see AWS CloudFormation generating the infrastructure, you can view the [CloudFormation console](https://console.aws.amazon.com/cloudformation/). The following image shows cluster creation in the CloudFormation console.

![ParallelCluster CloudFormation](/images/hpc-aws-parallelcluster-workshop/pc-cloudformation.png)