+++
title = "c. Provision FSx volume"
date = 2022-09-28T10:46:30-04:00
weight = 30
tags = ["tutorial", "hpc", "Kubernetes"]
+++

In this section, you will deploy the FSx CSI driver and create a Kubernetes storage class for FSx. You will then create a persistent volume claim using the storage clas, which will dynamically provision an FSx volume.


1. Create FSx policy

Copy the following policy document into a file named `fsx-policy.json`

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:CreateServiceLinkedRole",
        "iam:AttachRolePolicy",
        "iam:PutRolePolicy"
       ],
      "Resource": "arn:aws:iam::*:role/aws-service-role/fsx.amazonaws.com/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "fsx:*"
      ],
      "Resource": ["*"]
  }]
}
```

Then create the policy using the following AWS CLI command:

```bash
POLICY_ARN=$(aws iam create-policy --policy-name fsx-csi --policy-document file://fsx-policy.json --query "Policy.Arn" --output text)
echo "POLICY_ARN=$POLICY_ARN"
```

2. Attach policy to node instance profile

This is necessary to allow the nodes of your cluster to mount FSx volumes.

```bash
asg1_name=$(eksctl get nodegroups --cluster eks-hpc --region us-east-2 | grep -v NAME | head -n 1 | awk '{print $10}')
launch_template_name=$(aws autoscaling describe-auto-scaling-groups --auto-scaling-group-name=$asg1_name --region us-east-2 | jq -r .AutoScalingGroups[].MixedInstancesPolicy.LaunchTemplate.LaunchTemplateSpecification.LaunchTemplateName)
instance_profile_name=$(aws ec2 describe-launch-template-versions --versions '$Default' --launch-template-name=$launch_template_name --region us-east-2 | jq -r .LaunchTemplateVersions[].LaunchTemplateData.IamInstanceProfile.Name)
role_name=$(aws iam get-instance-profile --instance-profile-name $instance_profile_name --region us-east-2 --query InstanceProfile.Roles[0].RoleName --output text)
aws iam attach-role-policy --policy-arn ${POLICY_ARN} --role-name ${role_name}
```

3. Create security group 

Create a security group that allows TCP traffic on port 988 for FSx

```bash
instance1_id=$(aws autoscaling describe-auto-scaling-groups --auto-scaling-group-name=$asg1_name --region us-east-2 | jq -r .AutoScalingGroups[].Instances[0].InstanceId)
subnet_id=$(aws ec2 describe-instances --instance-id=$instance1_id --region us-east-2 | jq -r .Reservations[0].Instances[0].SubnetId)
SUBNET_CIDR=$(aws ec2 describe-subnets --region us-east-2 --query Subnets[?SubnetId=="'${subnet_id}'"].{CIDR:CidrBlock} --output text)
VPC_ID=$(aws ec2 describe-subnets --region us-east-2 --query Subnets[?SubnetId=="'${subnet_id}'"].{VpcId:VpcId} --output text)
SECURITY_GROUP_ID=$(aws ec2 create-security-group --vpc-id ${VPC_ID} --region us-east-2 --group-name eks-fsx-sg --description "FSx for Lustre Security Group" --query "GroupId" --output text)
aws ec2 authorize-security-group-ingress --group-id ${SECURITY_GROUP_ID} --region us-east-2 --protocol tcp --port 988 --cidr ${SUBNET_CIDR}
```

4. Deploy FSx CSI Driver

The following command deploys the FSx Container Storage Interface driver to your cluster:

```bash
kubectl apply -k "github.com/kubernetes-sigs/aws-fsx-csi-driver/deploy/kubernetes/overlays/stable/?ref=master"
```

5. Create storage class

Execute the following snippet to generate the storage class manifest (`fsx-storage-class.yaml`) and then apply it to the cluster

```bash
cat > fsx-storage-class.yaml <<EOF
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: fsx-sc
provisioner: fsx.csi.aws.com
parameters:
  subnetId: ${subnet_id}
  securityGroupIds: ${SECURITY_GROUP_ID}
EOF
kubectl apply -f fsx-storage-class.yaml
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

6. Dynamically provision FSx volume

Copy the persistent volume claim manifest below into a file named `fsx-pvc.yaml`:

```yaml
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
      storage: 1000Gi
```

Create a namespace `gromacs` in your cluster and a persistent volume claim `fsx-pvc` in this namespace, using the `fsx-sc` storage class. This dynamically creates an FSx persistent volume. Creation of the volume is expected to take 6-8 minutes.

```bash
kubectl create namespace gromacs
kubectl apply -f ./fsx-pvc.yaml
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

```
aws fsx describe-file-systems --region us-east-2
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
                "DeploymentType": "SCRATCH_1"
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
            "ResourceARN": "arn:aws:fsx:us-east-2:944270628268:file-system/fs-0a983bda1fd46d2f7", 
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