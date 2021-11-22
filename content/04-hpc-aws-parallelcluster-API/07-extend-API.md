+++
title = "g. Stop Clusters Fleets"
date = 2019-09-18T10:46:30-04:00
weight = 90
tags = ["tutorial", "initialize", "ParallelCluster"]
+++

In the previous step you saw how to use the AWS ParallelCluster API. You will now extend your code to stop the compute fleets of your cluster. This will prevent them from scaling and enable you to update them by changing the instance type or even adding new queues with different instance kinds. A reason for that is to enable your cluster to run workflows of jobs with mixed requirements.

Follow the steps below to list instances in your clusters using the AWS ParallelCluster API:

1. **Copy** the code below and past it in a AWS Cloud9 terminal. The code will be saved under the name `stop_clusters_fleets.py`.

```python
cat > stop_clusters_fleets.py << EOF
# utility libraries
import os
import json
from pprint import pprint

# pcluster client
import pcluster_client
from pcluster_client.api import cluster_operations_api,\
                                cluster_instances_api,\
                                cluster_compute_fleet_api

# dependencies top update the fleet state
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
    api_compute_fleet = cluster_compute_fleet_api.ClusterComputeFleetApi(api_client)

    # set the status to update the fleet
    compute_fleet_target_state = UpdateComputeFleetRequestContent(
        status=RequestedComputeFleetStatus("STOP_REQUESTED"),
    )

    print("Getting the list of clusters")
    clusters = api_cluster_operations.list_clusters()['clusters']

    print(f"You have {len(clusters)}")
    for cluster in clusters:
        print(cluster['cluster_name'])
        instances = api_cluster_instances.describe_cluster_instances(cluster['cluster_name'])
        pprint(instances["instances"])


    print("Stopping compute fleets")
    for cluster in clusters:
        fleet = api_compute_fleet.describe_compute_fleet(cluster['cluster_name'])
        print(f"fleet of cluster['cluster_name'] status -> {fleet['status']}")

        if str(fleet['status']) == 'RUNNING':
            new_status = api_compute_fleet.update_compute_fleet(
                cluster['cluster_name'], compute_fleet_target_state)
            print("Fleet status set to {newstatus}")

        fleet = api_compute_fleet.describe_compute_fleet(cluster['cluster_name'])
        print(f"fleet of cluster['cluster_name'] status -> {fleet['status']}")
EOF
```

2. As in the previous page, use a terminal on your AWS Cloud9 instance and ensure that your [`API_URL`](/04-hpc-aws-parallelcluster-api/03-retrieve-api-url.html) is set using `echo $API_URL` and execute your new Python script

```bash
python stop_clusters_fleets.py
```

3. You should see a result similar to the one in the image below.

![PCluster API](/images/hpc-aws-parallelcluster-workshop/pcapi-stop.png)

4. **Connect** to your PCluster Manager interface then check the status of the compute fleet. What do you see?


Now that you understand how to work with the PCluster API, how would you use it to delete clusters?
