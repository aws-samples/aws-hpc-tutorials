+++
title = "b. Provision FSx volume"
date = 2022-09-28T10:46:30-04:00
weight = 80
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
asg1_name=$(eksctl get nodegroups --cluster eks-hpc | grep -v NAME | head -n 1 | awk '{print $10}')
launch_template_name=$(aws autoscaling describe-auto-scaling-groups --auto-scaling-group-name=$asg1_name | jq -r .AutoScalingGroups[].MixedInstancesPolicy.LaunchTemplate.LaunchTemplateSpecification.LaunchTemplateName)
instance_profile_name=$(aws ec2 describe-launch-template-versions --versions '$Default' --launch-template-name=$launch_template_name | jq -r .LaunchTemplateVersions[].LaunchTemplateData.IamInstanceProfile.Name)
role_name=$(aws iam get-instance-profile --instance-profile-name $instance_profile_name --query InstanceProfile.Roles[0].RoleName --output text)
aws iam attach-role-policy --policy-arn ${POLICY_ARN --role-name ${role_name}
```

3. Create security group 

Create a security group that allows TCP traffic on port 988 for FSx

```bash
instance1_id=$(aws autoscaling describe-auto-scaling-groups --auto-scaling-group-name=$asg1_name | jq -r .AutoScalingGroups[].Instances[0].InstanceId)
subnet_id=$(aws ec2 describe-instances --instance-id=$instance1_id | jq -r .Reservations[0].Instances[0].SubnetId)
SUBNET_CIDR=$(aws ec2 describe-subnets --query Subnets[?SubnetId=="'${subnet_id}'"].{CIDR:CidrBlock} --output text)
VPC_ID=$(aws ec2 describe-subnets --query Subnets[?SubnetId=="'${subnet_id}'"].{VpcId:VpcId} --output text)
SECURITY_GROUP_ID=$(aws ec2 create-security-group --vpc-id ${VPC_ID} --group-name ${FSX_SECURITY_GROUP_NAME} --description "FSx for Lustre Security Group" --query "GroupId" --output text)
aws ec2 authorize-security-group-ingress --group-id ${SECURITY_GROUP_ID} --protocol tcp --port 988 --cidr ${SUBNET_CIDR}
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

TODO: add list here

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

Describe the persistent volume claim to check its status

```bash
kubectl -n gromacs describe pvc fsx-pvc
```
