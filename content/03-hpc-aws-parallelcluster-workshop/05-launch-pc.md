+++
title = "e. Build an HPC Cluster"
date = 2023-04-10T10:46:30-04:00
weight = 50
tags = ["tutorial", "create", "ParallelCluster"]
+++

In this section, you create a cluster based on the specifications defined in the configuration file. To create a cluster, you use the command **[pcluster create-cluster](https://docs.aws.amazon.com/parallelcluster/latest/ug/pcluster.create-cluster-v3.html)**.

In your AWS Cloud9 terminal, run the following to create a cluster. Make sure that the configuration file path is pointing to the `my-cluster-config.yaml` file created in the previous section. The Cluster name in this workshop is set within this line as `hpc-lab`.

```bash
pcluster create-cluster --cluster-name hpc-lab --suppress-validators ALL --cluster-configuration my-cluster-config.yaml
```

The cluster creation process will take ~10 minutes. Below is typical of the expected output after enter is pushed.

```bash
{
  "cluster": {
    "clusterName": "hpc-lab",
    "cloudformationStackStatus": "CREATE_IN_PROGRESS",
    "cloudformationStackArn": "arn:aws:cloudformation:eu-west-1:123456789:stack/hpc-lab/e47e8d00-e5df-11ed-b0eb-0604f1a65783",
    "region": "eu-west-1",
    "version": "3.5.1",
    "clusterStatus": "CREATE_IN_PROGRESS",
    "scheduler": {
      "type": "slurm"
    }
  }
}
```

If you want to see whether the create is in progress, you can use the `list-clusters` command:

```bash
pcluster list-clusters
```

This will show whether create is still in progress or completed. **Do not wait for the cluster creation to complete**; please proceed in the workshop instructions.

{{% notice note %}}
There can be only one cluster of a given name at any time on your account.
{{% /notice %}}

{{% notice info%}}
When the `pcluster create-cluster` command is executed, AWS ParallelCluster generates an **[AWS CloudFormation](https://aws.amazon.com/cloudformation/)** template to generate an infrastructure in AWS. The bulk of the work is done in AWS and once the create is launched, you don’t need to keep AWS ParallelCluster running.
{{% /notice %}}

In the next section you'll take a look at a visual alternative to the command line interface for deploying and managing your clusters called **ParallelCluster UI**.