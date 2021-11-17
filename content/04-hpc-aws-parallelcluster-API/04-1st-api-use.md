+++
title = "c. Install and test the Pcluster Client"
date = 2019-09-18T10:46:30-04:00
weight = 50
tags = ["tutorial", "initialize", "ParallelCluster"]
+++

Now that you have the API URL, you will start interacting with the API through its REST interface. This can be done directly through the [Python Requests](https://docs.python-requests.org/en/latest/) library or the [Pcluster Client](https://github.com/aws/aws-parallelcluster/tree/develop/api/client/src) library. You will use the latter for the reminder of this workshop.

For this step you will install the Pcluster Client library and run a sample code to list your clusters programmatically.

1. On AWS Cloud9, run the following command in a terminal to install the library.

```bash
pip3 install git+https://github.com/aws/aws-parallelcluster.git#subdirectory=api/client/src --user
```

2. Copy and paste the code below in a file on your AWS Cloud9 instance using the editor and save it under the name `list_clusters.py`.

```python
#!/usr/bin/env python3

# utility libraries
import os
from pprint import pprint

# pcluster client
import pcluster_client
from pcluster_client.api import cluster_operations_api


# configure the client, use the API URL retrieved from the AWS ParallelCluster API sack output
configuration = pcluster_client.Configuration(
    host = os.getenv("API_URL")
)

with pcluster_client.ApiClient(configuration) as api_client:
    # Create an instance of the API class
    api_instance = cluster_operations_api.ClusterOperationsApi(api_client)

    # list the clusters and print the result
    try:
        api_response = api_instance.list_clusters()
        pprint(api_response)
    # print an exception if an issue was encountered
    except pcluster_client.ApiException as e:
        print("Exception when calling ClusterOperationsApi->list_clusters: %s\n" % e)
```

3. In a terminal on AWS Cloud9, execute the file with Python. Ensure that you are running in the terminal where you retrieved the API URL. If not, run the script from the [previous page](/04-hpc-aws-parallelcluster-api/03-retrieve-api-url.html) to retrieve it again.

```bash
python list_clusters.py
```

4. Check if the cluster you created in *Part I* of the lab is listed as in the image below.

![Pcluster API](/images/hpc-aws-parallelcluster-workshop/pcapi-list.png)

5. Try to run the command `pcluster list-clusters` in your AWS Cloud9 terminal . The result should be comparable to the one you got using the AWS ParallelCluster API.

![AWS ParallelCluster CLI](/images/hpc-aws-parallelcluster-workshop/pcapi-cli-list.png)

You have been introduced to the AWS ParallelCluster API and the Pcluster Client. You also executed a command similar to the AWS ParallelCluster CLI to list your HPC clusters. Next, you will extend your Python code to identify clusters without compute instances and terminate them.

