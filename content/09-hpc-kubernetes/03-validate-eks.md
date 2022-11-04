+++
title = "c. Validate EKS cluster"
date = 2022-09-28T10:46:30-04:00
weight = 30
tags = ["tutorial", "hpc", "Kubernetes"]
+++

In this section, you will validate the newly created Amazon EKS cluster. 

#### 1. Validate Amazon EKS cluster creation

To validate that the cluster was provisioned successfully and is ready for use, you will list the Kubernetes nodes by executing the following command:

```bash
kubectl get nodes -o wide
```

You should see a list of two nodes similar to the one shown below.

```
NAME                             STATUS   ROLES    AGE     VERSION
ip-192-168-86-187.ec2.internal   Ready    <none>   4m54s   v1.21.14-eks-ba74326
ip-192-168-86-17.ec2.internal   Ready    <none>   4m54s   v1.21.14-eks-ba74326
```

**Troubleshooting**

* If the cluster creation fails with an ExpiredToken error (`ExpiredToken: The security token included in the request is expired`), ensure you have disabled the AWS Managed temporary credentials in your Cloud9 IDE following the instructions from the Preparation section [here](/02-aws-getting-started/06-iam-role.html).

* If your kubectl client is unable to connect to the cluster, you may try to update the connection information by executing the command below, then try validating the cluster again.

Use the command below, only ***if you were unable to connect*** to the cluster:
```bash
aws eks update-kubeconfig --name ${EKS_CLUSTER_NAME} --region ${AWS_REGION}
```
