+++
title = "c. Install AWS ParallelCluster"
date = 2023-04-10T10:46:30-04:00
weight = 30
tags = ["tutorial", "ParallelCluster", "Manager"]
+++

Continuing to use the terminal within the Cloud9 instance, use the pip install command to install AWS ParallelCluster. Python and Python package management tool (PIP) are already installed in the Cloud9 environment.
 

Install AWS ParallelCluster version 3.5.1:

```bash
pip3 install aws-parallelcluster==3.5.1 -U --user
```

This will take a couple of minutes. You can check the ParallelCluster installation completed successfully by running: 

```bash
pcluster version
```

The output should be:
```bash
{
  "version": "3.5.1"
}
```

Next, you will configure AWS ParallelCluster.