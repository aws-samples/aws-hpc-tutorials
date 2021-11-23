+++
title = "h. Exercise - Delete Clusters"
date = 2019-09-18T10:46:30-04:00
weight = 100
tags = ["tutorial", "initialize", "ParallelCluster"]
+++

In the previous steps you listed your clusters and stopped their compute fleet. How about deleting them?


In this exercise we will give you some hints but let you implement the solution.

1. Look at the [delete_cluster](https://github.com/aws/aws-parallelcluster/blob/develop/api/client/src/docs/ClusterOperationsApi.md#delete_cluster) API call.

2. Add the following code to delete clusters. Don't forget to replace `cluster_name` by the name of the cluster. You can alternatively loop over the list of clusters like in the example in the previous page.

```python
api_cluster_operations.delete_cluster(cluster_name)
```


Have you been able to trigger the deletion your clusters? If so, feel free to explore other [API functionalities](https://github.com/aws/aws-parallelcluster/tree/develop/api/client/src). You are now arrived at the end of this tutorial.
