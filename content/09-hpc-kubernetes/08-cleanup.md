+++
title = "h. Cleanup and Conclusion"
date = 2022-09-28T10:46:30-04:00
weight = 80
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

This command will delete the EKS cluster through AWS CloudFormation. The process will take several minutes to complete.

#### Conclusion

Congratulations!

You have provisioned a Kubernetes cluster and ran an HPC application on it, using Kubeflow MPI Operator. 

The experience obtained through this lab can be used when running your own HPC jobs on Kubernetes! 

Read the [next section](/09-hpc-kubernetes/09-homework.html) to learn about scaling out this architecture with EFA-enabled nodes on a multi-node cluster in your own AWS account.