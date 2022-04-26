+++
title = "g. Optimization of Instance Selection"
date = 2019-09-18T10:46:30-04:00
weight = 80
tags = ["tutorial", "install", "AWS", "batch", "packer"]
+++

In this section we will explore why we should optimize the instance selection in your Compute Environments.

#### Optimization of instance selection in your Compute Environments

The instances you get through AWS Batch are picked based the number of jobs and their shapes in terms of number of vCPUs and amount of memory they require. 

##### Case 1:
If they have low requirements (1-2 vCPUs, <4GB of memory) then it is likely that you will get small instances from Amazon EC2 (i.e., c5.xlarge) since they can be cost effective and belong to the deepest Spot instances pools. In this case, the challenge is using exclusively small instances can lead you to attain the maximum number of Container Instances per ECS Cluster (sitting beneath each Compute Environment) and therefore potentially hinder your ability to run at large scale. 

One solution to this challenge is to use larger instances in your Compute Environments configuration and help you achieve the desired capacity while staying under the limit imposed by ECS per cluster. To solve that, you need visibility on the instances picked for you.

##### Case 2:
Another case where observability on your AWS Batch environment is important is when your jobs need storage scratch space when running. If you set your EBS volumes to a fixed size and let Batch pick instances, smalls or larges, you may see some jobs crash on larger instances due to DockerTimeoutErrors or CannotInspectContainerError on large instances. This can be due to the higher number of jobs packed per instance which will consume your EBS Burst balance and process IO operations at a slow pace which prevents Docker to run checksums before its timeout. 

While the solution is to increase the EBS volume sizes for your launch templates or prefer Instance Store backed EC2 instances. Having the visibility to link job failures to instance kinds is helpful in quickly determining the relevant solutions.

Getting a deeper understanding of your job profile and your AWS Batch architecture is key for optimization for both cost and scale.

{{% notice info %}}
To help you in understanding and tuning your AWS Batch architectures, we developed and published a new open-source [observability solution](https://github.com/aws-samples/aws-batch-runtime-monitoring) on Github. This solution was built to run at scale and provide metrics that you can use to evaluate your AWS Batch architectures.  
{{% /notice %}}
