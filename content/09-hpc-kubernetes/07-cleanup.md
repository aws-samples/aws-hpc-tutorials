+++
title = "g. Cleanup"
date = 2022-09-28T10:46:30-04:00
weight = 80
tags = ["tutorial", "hpc", "Kubernetes"]
+++

In this section, you will delete the FSx volume and remove the EKS cluster that you created for this lab.

1. Delete FSx volume

Cleanup resources using the FSX volume
```
kubectl delete namespace gromacs
```

TODO: add aws cli commands to delete the FSX volume itself and check that it is deleted

2. Remove EKS cluster

```
eksctl delete cluster -f ./eks-hpc.yaml
```

TODO: add aws cli commands to show the cluster is deleted
