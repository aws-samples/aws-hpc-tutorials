+++
title = "i. Interact with Slurm through your API"
date = 2019-09-18T10:46:30-04:00
weight = 250
tags = ["tutorial", "serverless", "ParallelCluster", "Lambda", "Slurm", "API Gateway"]
+++

In the previous sections, you created a serverless function then bound a API Gateway to this function and trigger it using HTTPS calls. This function translates the arguments provided to the API Gateway, then connects to the head node through a secure channel and executes the commands. In this section, you will use with your new HTTPS API and interact with Slurm using [cURL](https://en.wikipedia.org/wiki/CURL).
