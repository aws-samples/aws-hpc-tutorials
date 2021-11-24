+++
title = "f. List Clusters & Instances via the API"
date = 2019-09-18T10:46:30-04:00
weight = 80
tags = ["tutorial", "initialize", "ParallelCluster"]
+++

Now that you have the API URL, you will start interacting with the API through its REST interface. This can be done directly through the [Python Requests](https://docs.python-requests.org/en/latest/) library or the [PCluster Client](https://github.com/aws/aws-parallelcluster/tree/develop/api/client/src) library. You will use the latter for the reminder of this workshop.

For this step you will install the PCluster Client library and run a sample code to list your clusters programmatically.

1. On AWS Cloud9, run the following command in a terminal to install the library and AWS ParallelCluster

```bash
pip3 install git+https://github.com/aws/aws-parallelcluster.git#subdirectory=api/client/src --use-feature=2020-resolver --user
pip3 install "aws-parallelcluster>=3" --use-feature=2020-resolver --user
```

2. **Copy** the code below and **paste** it in a AWS Cloud9 terminal. The code will be saved under the name `list_clusters.py`.

```python
cat > list_clusters.py << EOF
#!/usr/bin/env python3

# utility libraries
import os
import json
from pprint import pprint

# pcluster client
import pcluster_client
from pcluster_client.api import cluster_operations_api,\
                                cluster_instances_api,\
                                cluster_compute_fleet_api
from pcluster_client.model.update_compute_fleet_request_content import UpdateComputeFleetRequestContent
from pcluster_client.model.requested_compute_fleet_status import RequestedComputeFleetStatus
# configure the client, use the API URL retrieved from the AWS ParallelCluster API sack output
configuration = pcluster_client.Configuration(
    host = os.getenv("API_URL")
)

with pcluster_client.ApiClient(configuration) as api_client:
    # Create an instance of the Cluster, Instances and Compute Fleet API classes
    api_cluster_operations = cluster_operations_api.ClusterOperationsApi(api_client)
    api_cluster_instances = cluster_instances_api.ClusterInstancesApi(api_client)

    print("Getting the list of clusters")
    clusters = api_cluster_operations.list_clusters()['clusters']

    print(f"You have {len(clusters)}")
    for cluster in clusters:
        print(cluster['cluster_name'])
        instances = api_cluster_instances.describe_cluster_instances(cluster['cluster_name'])
        pprint(instances["instances"])
EOF
```

3. In a terminal on AWS Cloud9, execute the file with Python. Ensure that you are running in the terminal where you retrieved the API URL. If not, run the script from the [previous page](/04-hpc-aws-parallelcluster-api/03-retrieve-api-url.html) to retrieve it again.

```bash
python3 list_clusters.py
```

4. You should see a result similar to the one in the image below.

![PCluster API](/images/hpc-aws-parallelcluster-workshop/pcapi-list.png)

5. You can get same result using the AWS ParallelCluster CLI and piping multiple commands in your AWS Cloud9 terminal by running the code below.

```bash
pcluster list-clusters --query "clusters[0].clusterName"
```

Now that you understand how to retrieve information about your clusters, let's use this knowledge to stop unused clusters.
