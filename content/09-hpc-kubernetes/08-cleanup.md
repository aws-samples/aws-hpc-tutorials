+++
title = "h. Cleanup"
date = 2022-09-28T10:46:30-04:00
weight = 80
tags = ["tutorial", "hpc", "Kubernetes"]
+++

In this section, you will delete the FSx for Lustre file system and the EKS cluster that you created for this lab.

#### 1. Delete FSx for Lustre PVC

Cleanup resources that may have the FSX volume mounted.

```bash
kubectl delete -f ~/environment/fsx-pvc.yaml
```

#### 2. Delete resources belonging to the namespace.

```bash
kubectl delete namespace gromacs
```

#### 3. Delete EKS cluster

```bash
eksctl delete cluster -f ~/environment/eks-hpc.yaml
```

This command will delete the EKS cluster through AWS CloudFormation.