+++
title = "g. Cleanup"
date = 2022-09-28T10:46:30-04:00
weight = 80
tags = ["tutorial", "hpc", "Kubernetes"]
+++

In this section, you will delete the FSx file system and the EKS cluster that you created for this lab.

1. Delete FSx volume

Cleanup resources that may have the FSX volume mounted.

```
kubectl delete namespace gromacs
```

TODO: Detach FSx policy from intance profile

```bash
POLICY_ARN=$(aws iam list-policies --query Policies[?PolicyName=="'${FSX_POLICY_NAME}'"].{Arn:Arn} --output text)
```

2. Delete EKS cluster

```
eksctl delete cluster -f ./eks-hpc.yaml
```

This command will delete the cluster stack in CloueFormation