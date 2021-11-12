+++
title = "d. List your clusters instances"
date = 2019-09-18T10:46:30-04:00
weight = 60
tags = ["tutorial", "initialize", "ParallelCluster"]
+++


In this section you will extend your code to list the instances attached to your clusters. For that you need to list the AWS ParallelCluster clusters you created and use the [*list_clusters*](https://github.com/aws/aws-parallelcluster/blob/develop/api/client/src/docs/ClusterOperationsApi.md#list_clusters) function from the [Pcluster Client](https://github.com/aws/aws-parallelcluster/tree/develop/api/client/src).

Compare the code used in the previous step to the one below. You will notice a few changes:

- Another API called `cluster_instances_api` has been imported from the module `pcluster_client.api`.
- The clusters are retrieved from the `list_clusters` api response.
- A new API call is made with `describe_cluster_instances` for each cluster to retrieve the list of its instances.

Follow the steps below to list instances in your clusters using the AWS ParallelCluster API:

1. Create a new file on your AWS Cloud9 instance and name it `list_clusters_instances.py` and paste the code below.

```python
#!/usr/bin/env python3

# utility libraries
import os
from pprint import pprint
# pcluster client and common exceptions
import pcluster_client
from pcluster_client.api import cluster_operations_api,cluster_instances_api
from pcluster_client.model.bad_request_exception_response_content import BadRequestExceptionResponseContent
from pcluster_client.model.cluster_status_filtering_option import ClusterStatusFilteringOption
from pcluster_client.model.unauthorized_client_error_response_content import UnauthorizedClientErrorResponseContent
from pcluster_client.model.limit_exceeded_exception_response_content import LimitExceededExceptionResponseContent
from pcluster_client.model.list_clusters_response_content import ListClustersResponseContent
from pcluster_client.model.internal_service_exception_response_content import InternalServiceExceptionResponseContent

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
            print(f"Listing instances for cluster: {cluster['cluster_name']}")
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

