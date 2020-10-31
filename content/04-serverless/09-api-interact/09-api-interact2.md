+++
title = "- List instances and partitions"
date = 2019-09-18T10:46:30-04:00
weight = 255
tags = ["tutorial", "serverless", "ParallelCluster", "Lambda", "Slurm", "API Gateway"]
+++

To interact wit your API you will be using [cURL](https://en.wikipedia.org/wiki/CURL), it is a tool commonly used to interact with HTTP(s) servers. cURL is already installed on your Cloud9 instance.

1. Without logging into your cluster, start by running the following command in the Cloud9 terminal to **list the compute nodes** attached to your Slurm cluster.

      ```bash
         curl -s POST "${INVOKE_URL}/slurm?instanceid=${HEAD_NODE_ID}&function=list_nodes" # Note the function name  "list_nodes"
      ```
2. Initiate a second cURL call to **list the partitions** in your cluster

      ```bash
      curl -s POST "${INVOKE_URL}/slurm?instanceid=${HEAD_NODE_ID}&function=list_partitions" # Note the function name "list_partitions"
      ```
