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

The cluster creation process will take ~10 minutes. Below is the expected output.

```bash
TeamRole:~/environment $ source env_vars
TeamRole:~/environment $ pcluster create-cluster --region ${AWS_REGION} --cluster-name hpc-cluster-lab --suppress-validators ALL --cluster-configuration my-cluster-config.yaml
{
  "cluster": {
    "clusterName": "hpc-cluster-lab",
    "cloudformationStackStatus": "CREATE_IN_PROGRESS",
    "cloudformationStackArn": "arn:aws:cloudformation:eu-west-1:146043110428:stack/hpc-cluster-lab/4934f020-bca3-11ec-9752-0ecc1f64971f",
    "region": "eu-west-1",
    "version": "3.1.2",
    "clusterStatus": "CREATE_IN_PROGRESS"
  },
}
```

{{% notice tip %}}
There can be only one cluster of a given name at any time on your account.
{{% /notice %}}

In the next section you'll take a look at a visual alternative to the command line interface for deploying and managing your clusters called **pcluster-manager**.