---
title: "e. Set up CloudWatch metrics"
date: 2022-08-19
weight: 70
tags: ["Ray", "CloudWatch"]
---

AWS CloudWatch agent is already installed on the ubuntu AMI we used in the previous step. To setup CloudWatch in Ray cluster, we need to specify the all the metrics we wish to send to the CloudWatch in a config file. This is done by creating a json file. Save the following json to cloudwatch-agent-config.json**cloudwatch-agent-config.json**:

```json
{
    "agent": {
        "metrics_collection_interval": 10,
        "run_as_user": "root"
    },
    "metrics": {
        "namespace": "ray-{cluster_name}-CWAgent",
        "append_dimensions": {
            "InstanceId": "${aws:InstanceId}"
        },
        "metrics_collected": {
            "cpu": {
                "measurement": [
                    "usage_active",
                    "usage_system",
                    "usage_user"
                ]
            },
            "nvidia_gpu": {
                "measurement": [
                    "utilization_gpu",
                    "utilization_memory",
                    "memory_used"
                ],
                "metrics_collection_interval": 10
            },
            "mem": {
                "measurement": [
                    "mem_used_percent"
                ],
                "metrics_collection_interval": 10
            }
        }
    }
}
```

We will use this file in the cluster configuration.
