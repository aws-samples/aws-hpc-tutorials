+++
title = "Checking the environment"
date = 2023-04-10T10:46:30-04:00
weight = 30
tags = ["tutorial", "ParallelCluster", "initialize"]
+++

Before proceeding, make a quick check that you have both clusters deployed. You should see two, one called "onprem" and one called "cloud".

```bash
[ec2-user@server ~]$ pcluster list-clusters -r eu-west-1 
{
  "clusters": [
    {
      "clusterName": "onprem",
      "cloudformationStackStatus": "CREATE_COMPLETE",
      "cloudformationStackArn": "arn:aws:cloudformation:eu-west-1:196438911214:stack/onprem/c31c53e0-34d7-11ed-959e-02e9eca6697f",
      "region": "eu-west-1",
      "version": "3.5.1",
      "clusterStatus": "CREATE_COMPLETE",
      "scheduler": {
        "type": "slurm"
      }
    },
    {
      "clusterName": "cloud",
      "cloudformationStackStatus": "CREATE_COMPLETE",
      "cloudformationStackArn": "arn:aws:cloudformation:eu-west-1:196438911214:stack/cloud/c31c53e0-34d7-11ed-959e-02e9eca6697f",
      "region": "eu-west-1",
      "version": "3.5.1",
      "clusterStatus": "CREATE_COMPLETE",
      "scheduler": {
        "type": "slurm"
      }
    },
  ]
}
```

You may see other clusters that you have created earlier today, if you haven’t already cleaned up.

You should also see the database that has been pre installed for you.

```bash
[ec2-user@server ~]$ aws cloudformation --region ${AWS_REGION} describe-stacks --stack-name clusterdb | jq '.Stacks'[0]'.Outputs' | jq 'map(select(.OutputKey == "DatabaseHost"))'
[
  {
    "OutputKey": "DatabaseHost",
    "OutputValue": "slurm-accounting-cluster.cluster-cshiwt8faqp5.eu-west-1.rds.amazonaws.com"
  }
]
```

Assuming you can see the two HPC Clusters and the database it is ok to proceed. If not please ask one of the workshop staff.
