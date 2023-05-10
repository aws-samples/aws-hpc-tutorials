+++
title = "Architecture"
date = 2023-04-10T10:46:30-04:00
weight = 40
tags = ["tutorial", "initialize", "ParallelCluster"]
+++

At the moment we have the following configuration built.

![Starting Architecture](/images/federation-and-cache/as-deployed.png)

There are two clusters, both setup with AWS Parallel Cluster. There is no special setup one these two clusters, they are very much standard. However I would note that they do both have consistent user ids and home directories. This isn't a hard requirement, but it does make life much easier. Both clusters are setup to communicate with different databases on the same database server. They are not aware of each other, jobs sent to one cluster will never run on the other. We will configure that in the next steps. After configuration the setup will look like the picture below.

![Final Architecture](/images/federation-and-cache/final-architecture.png)


