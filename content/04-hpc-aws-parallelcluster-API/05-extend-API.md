+++
title = "d. Delete Empty Clusters via the API"
date = 2019-09-18T10:46:30-04:00
weight = 60
tags = ["tutorial", "initialize", "ParallelCluster"]
+++

In this section you will extend your code to list the instances attached to your clusters and delete the clusters if no compute nodes exists (hence no jobs are running). For that, you need to list the AWS ParallelCluster clusters you created and use the [*list_clusters*](https://github.com/aws/aws-parallelcluster/blob/develop/api/client/src/docs/ClusterOperationsApi.md#list_clusters) function from the [Pcluster Client](https://github.com/aws/aws-parallelcluster/tree/develop/api/client/src). Then you will use the [*delete_cluster*](https://github.com/aws/aws-parallelcluster/blob/develop/api/client/src/docs/ClusterOperationsApi.md#delete_cluster) function to delete empty clusters.

#### Describing instances

In this example, you start by comparing the code used in the [previous step](/04-hpc-aws-parallelcluster-api/04-1st-api-use.html) to the one below. For example using the AWS Cloud9 editor for convenience. You will notice a few changes:

- The clusters are retrieved from the `list_clusters` api response.
- A new API call is made with `describe_cluster_instances` for each cluster to retrieve the list of its instances.

Follow the steps below to list instances in your clusters using the AWS ParallelCluster API:

1. Create a new file on your AWS Cloud9 instance and name it `list_clusters_instances.py` and paste the code below.

```python
#!/usr/bin/env python3

# utility libraries
import os
from pprint import pprint

# pcluster client
import pcluster_client
from pcluster_client.api import cluster_operations_api,cluster_instances_api

# configure the client, use the API URL retrieved from the AWS ParallelCluster API sack output
configuration = pcluster_client.Configuration(
    host = os.getenv("API_URL")
)

with pcluster_client.ApiClient(configuration) as api_client:
    # Create an instance of the API class
    api_instance_operations = cluster_operations_api.ClusterOperationsApi(api_client)

    # Create the compute fleet API
    api_instance_instances = cluster_instances_api.ClusterInstancesApi(api_client)

    # list the clusters and print the result
    try:
        api_response = api_instance_operations.list_clusters()
        clusters = api_response['clusters']
    # print an exception if an issue was encountered
    except pcluster_client.ApiException as e:
        print("Exception when calling ClusterOperationsApi->list_clusters: %s\n" % e)

    # list the instances for each cluster
    try:
        for cluster in clusters:
            api_response = api_instance_instances.describe_cluster_instances(cluster['cluster_name'])
            print(f"Listing instances for cluster: {cluster['cluster_name']} ")
            pprint(api_response)
    # print an exception if an issue was encountered
    except pcluster_client.ApiException as e:
        print("Exception when calling ClusterInstancesApi->describe_cluster_instances: %s\n" % e)

```

2. Once saved, use a terminal on your AWS Cloud9 instance and ensure that your [API URL](/04-hpc-aws-parallelcluster-api/03-retrieve-api-url.html) is set and execute it.

```python
python list_clusters_instances.py
```

3. You should see a result similar to the one in the image below.

![Pcluster API](/images/hpc-aws-parallelcluster-workshop/pcapi-list.png)

4. You can get same result using the AWS ParallelCluster CLI and piping multiple commands in your AWS Cloud9 terminal by running the code below.

```bash
pcluster list-clusters | jq -r ".clusters[].clusterName" | xargs pcluster describe-cluster-instances --cluster-name
```

Now that you understand how to retrieve information about your clusters, let's use this knowledge to terminate unused clusters. While you can stop the compute instance fleet, the head-node and shared storage will continue to run. The termination removes all its resources, including the head-node and storage.

#### Terminate empty clusters

Start by adding a few lines of code at the end of your script to delete empty clusters (it should be already indented). You can optionally duplicate the file and name it `delete_clusters.py`. Then execute it with the command `python delete_cluster.py`

```python
    # check for empty clusters
    for cluster in clusters:
        api_response = api_instance_instances.describe_cluster_instances(cluster['cluster_name'])
        n_compute = len([node for node in api_response['instances'] if str(node['node_type']) == "ComputeNode"])

        # if there are no compute instances
        print(f"Cluster {cluster['cluster_name']} contains {n_compute} compute nodes")
        if n_compute == 0:
            print("Deleting empty cluster {cluster['cluster_name']}")
            try:
                api_response = api_instance_operations.delete_cluster(cluster['cluster_name'])
                pprint(api_response)
            except pcluster_client.ApiException as e:
                print("Exception when calling ClusterOperationsApi->delete_cluster: %s\n" % e)
```

You will see a result similar to the screenshot below. The status of the cluster will be in `DELETE_IN_PROGRESS`.


![AWS ParallelCluster API - Cluster Deletion](/images/hpc-aws-parallelcluster-workshop/pcapi-delete-cluster.png)

You can verify the state of the delete clusters using the AWS ParallelCluster CLI with the command `pcluster list-clusters`. In the next section you will see how the AWS ParallelCluster API can be used to build custom features.
