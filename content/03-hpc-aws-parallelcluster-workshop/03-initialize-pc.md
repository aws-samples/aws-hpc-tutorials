+++
title = "c. (Optional) Create config with 'pcluster configure'"
date = 2019-09-18T10:46:30-04:00
weight = 50
tags = ["tutorial", "initialize", "ParallelCluster"]
+++

**Optionally**, you can also create a cluster configuration file in AWS ParallelCluster using the command-line: `pcluster configure --config config.yaml`, in your cloud9 shell and walk through the configure menu. This step generates a config file which you can modify further as needed.

```yaml
$ pcluster configure --config config.yaml
INFO: Configuration file test will be written.
Press CTRL-C to interrupt the procedure.


Allowed values for AWS Region ID:
1. ap-northeast-1
. . .
16. us-west-2
AWS Region ID [eu-west-1]: eu-west-1

Allowed values for EC2 Key Pair Name:
1. lab-your-key
EC2 Key Pair Name [your-key]: #This is where you type the name of the key you previously generated (e.g. lab-your-key) 

Allowed values for Scheduler:
1. slurm
2. awsbatch
Scheduler [slurm]: slurm

Allowed values for Operating System:
1. alinux2
2. centos7
3. ubuntu1804
4. ubuntu2004
Operating System [alinux2]: alinux2

Head node instance type [t2.micro]: c5.xlarge
Number of queues [1]: 1
Name of queue 1 [queue1]: compute
Number of compute resources for compute [1]: 1
Compute instance type for compute resource 1 in compute [t2.micro]: c5.xlarge
Maximum instance count [10]: 8
Automate VPC creation? (y/n) [n]: y

Allowed values for Availability Zone:
1. eu-west-1a
2. eu-west-1b
3. eu-west-1c
Availability Zone [eu-west-1a]: eu-west-1a

Allowed values for Network Configuration:
1. Head node in a public subnet and compute fleet in a private subnet
2. Head node and compute fleet in the same public subnet
Network Configuration [Head node in a public subnet and compute fleet in a private subnet]: 1

Beginning VPC creation. Please do not leave the terminal until the creation is finalized
Creating CloudFormation stack...
Do not leave the terminal until the process has finished.

Stack Name: parallelclusternetworking-pubpriv-20211116161450 (id: arn:aws:cloudformation:eu-west-1:008xxxxxx:stack/parallelclusternetworking-pubpriv-20211116161450/680fea70-46f8-11ec-b10b-022a17eafb09)
Status: parallelclusternetworking-pubpriv-20211116161450 - CREATE_COMPLETE      

The stack has been created.
Configuration file written to config.yaml
You can edit your configuration file or simply run 'pcluster create-cluster --cluster-configuration config.yaml --cluster-name cluster-name --region eu-west-1' to create your cluster.
```

Now, you can check the contents of this configuration file:

```yaml
$ cat config.yaml

Region: eu-west-1
Image:
  Os: alinux2
HeadNode:
  InstanceType: c5.xlarge
  Networking:
    SubnetId: subnet-xxxxxxxxxxx
  Ssh:
    KeyName: lab-your-key
Scheduling:
  Scheduler: slurm
  SlurmQueues:
  - Name: compute
    ComputeResources:
    - Name: c5xlarge
      InstanceType: c5.xlarge
      MinCount: 0
      MaxCount: 8
    Networking:
      SubnetIds:
      - subnet-yyyyyyyyyy
```

This configuration file allows you to create a simple cluster with the minimum required information. A default configuration file is good to have for testing purposes.

Next, you build a configuration to generate an optimized cluster to run typical "tightly coupled" HPC applications.
