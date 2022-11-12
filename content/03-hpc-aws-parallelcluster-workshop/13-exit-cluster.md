+++
title = "m. Summary"
date = 2022-04-10T10:46:30-04:00
weight = 130
tags = ["tutorial", "create", "ParallelCluster"]
+++

Congratulations, you have deployed a HPC Cluster on AWS !

In this lab, you have:
- Configured your HPC Cluster
- Deployed a HPC Cluster in the cloud.
- Run a tighly couple application: WRF on the CONUS 12KM test case.

In the next lab, you will learn about [Amazon FSx for Lustre](https://aws.amazon.com/fsx/lustre/).

We need to stop the compute fleet, so we can update it in the next lab. In your **AWS Cloud9** terminal window paste the following command

```bash
pcluster update-compute-fleet -n hpc-cluster-lab --status STOP_REQUESTED --region ${AWS_REGION}
```


You can learn more about AWS ParallelCluster by visiting the [documentation](https://docs.aws.amazon.com/parallelcluster/latest/ug/what-is-aws-parallelcluster.html).


Please do not close your Cloud9 session, as it will be used in later labs.
