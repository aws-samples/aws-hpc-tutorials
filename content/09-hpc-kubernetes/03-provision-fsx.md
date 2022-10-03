+++
title = "c. Provision FSx for Lustre persistent volume"
date = 2022-09-28T10:46:30-04:00
weight = 30
tags = ["tutorial", "hpc", "Kubernetes"]
+++

In this section, you will create a FSx for Lustre file system and exposed as a resource in Kubernetes to be used by your application pods.

To begin, you will deploy The FSx for Lustre Container Storage Interface (CSI) driver. It provides a CSI interface that allows Amazon EKS clusters to manage the lifecycle of FSx for Lustre file systems.
Then, you will create a Kubernetes `StorageClass` for FSx for Lustre. A Kubernetes `StorageClass` is a Kubernetes storage mechanism that lets you provision persistent volumes (PV) in a Kubernetes cluster and then pods can dynamically request the specific type of storage they need.
To finish, you will create a persistent volume claim (PVC) using the `StorageClass` created previously that will dynamically provision an FSx for Lustre volume. A PVC is a request for storage by a user that consumes PV. It is similar to a Pod that consumes node resources.


#### 1. Deploy FSx CSI Driver

The following command deploys the FSx Container Storage Interface driver to your cluster:

```bash
kubectl apply -k "github.com/kubernetes-sigs/aws-fsx-csi-driver/deploy/kubernetes/overlays/stable/?ref=release-0.8"
```

#### 2. Retrieve security group of cluster

Create a security group that allows TCP traffic on port 988 for FSx

```bash
SECURITY_GROUP_ID=`aws eks describe-cluster --name ${EKS_CLUSTER_NAME} --query cluster.resourcesVpcConfig.clusterSecurityGroupId --region ${AWS_REGION}`
```

#### 3. Retrieve subnet id of node group

```bash
SUBNET_ID=`aws eks describe-nodegroup --cluster-name ${EKS_CLUSTER_NAME} --nodegroup-name "c5n-18xl" --query nodegroup.subnets --region ${AWS_REGION} | jq -r '.[]'`
```

#### 4. Create storage class

Execute the following snippet to generate the storage class manifest (`fsx-storage-class.yaml`) and then apply it to the cluster

```bash
cat > ~/environment/fsx-storage-class.yaml << EOF
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: fsx-sc
provisioner: fsx.csi.aws.com
parameters:
  subnetId: ${SUBNET_ID}
  securityGroupIds: ${SECURITY_GROUP_ID}
  deploymentType: SCRATCH_2
  storageType: SSD
EOF
```

```bash
kubectl apply -f ~/environment/fsx-storage-class.yaml
```

To verify that the storage class is create successfully, execute:

```bash
kubectl get storageclass
```

You should see a list, similar to the following:

```text
NAME            PROVISIONER             RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
fsx-sc          fsx.csi.aws.com         Delete          Immediate              false                  9s
gp2 (default)   kubernetes.io/aws-ebs   Delete          WaitForFirstConsumer   false                  16h
```

#### 6. Dynamically provision FSx volume

Copy the persistent volume claim manifest below into a file named `fsx-pvc.yaml`:

```bash
cat > ~/environment/fsx-pvc.yaml << EOF
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: fsx-pvc
  namespace: gromacs
spec:
  accessModes:
    - ReadWriteMany
  storageClassName: fsx-sc
  resources:
    requests:
      storage: 1200Gi
EOF
```

Create a namespace `gromacs` in your cluster and a persistent volume claim `fsx-pvc` in this namespace, using the `fsx-sc` storage class. This dynamically creates an FSx persistent volume. Creation of the volume is expected to take 6-8 minutes.

```bash
kubectl create namespace gromacs
kubectl apply -f ~/environment/fsx-pvc.yaml
```

Select the persistent volume claim to check its status

```bash
kubectl -n gromacs get pvc fsx-pvc
```

While the You should see output like the following:

```text
NAME      STATUS    VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   AGE
fsx-pvc   Pending                                      fsx-sc         2m39s
```

Describe the FSx file systems in your account to see the current status

```bash
aws fsx describe-file-systems --region ${AWS_REGION}
```

You should see output like the following:

```json
{
    "FileSystems": [
        {
            "VpcId": "vpc-09e19ec07fd43d433", 
            "LustreConfiguration": {
                "CopyTagsToBackups": false, 
                "WeeklyMaintenanceStartTime": "7:07:30", 
                "DataCompressionType": "NONE", 
                "MountName": "fsx", 
                "DeploymentType": "SCRATCH_2"
            }, 
            "Tags": [
                {
                    "Value": "pvc-159049a3-d25d-465f-ad7e-3e0799756fce", 
                    "Key": "CSIVolumeName"
                }
            ], 
            "StorageType": "SSD", 
            "SubnetIds": [
                "subnet-07a7858f836ad4bb4"
            ], 
            "FileSystemType": "LUSTRE", 
            "CreationTime": 1664481419.438,
            "ResourceARN": "arn:aws:fsx:us-east-2:111122223333:file-system/fs-0a983bda1fd46d2f7", 
            "StorageCapacity": 1200, 
            "NetworkInterfaceIds": [
                "eni-04b75f9deb999568f", 
                "eni-0c4695b00d3033f2c"
            ], 
            "FileSystemId": "fs-0a983bda1fd46d2f7", 
            "DNSName": "fs-0a983bda1fd46d2f7.fsx.us-east-2.amazonaws.com", 
            "OwnerId": "944270628268", 
            "Lifecycle": "AVAILABLE"
        }
    ]
}
```

The **Lifecycle** field indicates the current status. It is expected that the status will be **CREATING** for about 7 minutes. When the provisioning is complete, the status will change to **CREATED**. 

And the status of the persistent volume claim in Kubernetes will change to **Bound**

```bash
kubectl -n gromacs get pvc fsx-pvc
```

Output:

```text
NAME      STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
fsx-pvc   Bound    pvc-159049a3-d25d-465f-ad7e-3e0799756fce   1200Gi     RWX            fsx-sc         7m45s
```

The FSx volume is now provisioned and ready to attach to pods.