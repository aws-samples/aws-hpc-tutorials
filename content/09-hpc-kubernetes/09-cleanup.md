+++
title = "i. Cleanup and Conclusion"
date = 2022-09-28T10:46:30-04:00
weight = 90
tags = ["tutorial", "hpc", "Kubernetes"]
+++

In this section, you will delete the FSx for Lustre file system and the EKS cluster that you created for this lab.

#### 1. Delete resources belonging to the namespace.

Execute the following command to remove all Kubernetes resources that were created in the gromacs namespace:

```bash
kubectl delete namespace gromacs
```

When the persistent volume claim is deleted, the FSx for Lustre volume will automatically be deleted as well.

#### 2. Delete EKS cluster

To delete the cluster, execute:

```bash
eksctl delete cluster -f ~/environment/eks-hpc.yaml
```

This command will delete the EKS cluster through AWS CloudFormation. It will take several minutes to complete.

#### Conclusion

Congratulations!

You have provisioned a Kubernetes cluster with HPC capabilities and monitoring. 

You ran a distributed tightly-coupled workload using Kubeflow MPI Operator. 

The experience obtained through this lab can be used when running your own HPC jobs on Kubernetes! 