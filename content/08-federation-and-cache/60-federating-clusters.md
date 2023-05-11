+++
title = "Federating the clusters"
date = 2023-04-10T10:46:30-04:00
weight = 60
tags = ["tutorial", "ParallelCluster", "Manager"]
+++

{{% notice warning %}} Log out of the cluster and return to the Cloud9 instance. {{% /notice %}}

To federate the two clusters we need to attach them both to the same SlurmDBD service. In this example we will attach the cloud cluster to the SlurmDBD running in on the onprem cluster. 

Before we can reconfigure the cluster we need to open the security groups on the headnodes so they can talk to each other. In this example we will permit access to the headnodes from any machine in the VPC. In a production setting you might want to limit this more, maybe to the specific instance.

First lets get the instance IDs for the headnodes. Ensure you are logged into the Cloud 9 instance, not one of the clusters.

```bash
export ONPREM_INSTANCEID=`pcluster describe-cluster -n onprem -r eu-west-1 | jq '.headNode.instanceId' | sed s/\"//g`
echo $ONPREM_INSTANCEID
i-0142d727aaced581c
export CLOUD_INSTANCEID=`pcluster describe-cluster -n cloud -r eu-west-1 | jq '.headNode.instanceId' | sed s/\"//g`
echo $CLOUD_INSTANCEID
i-0142d727aaced581c
```

Now lets see which security groups are attached to the headnodes.

```bash
aws ec2 describe-security-groups --group-ids $(aws ec2 describe-instances --instance-id $ONPREM_INSTANCEID --query "Reservations[].Instances[].SecurityGroups[].GroupId[]" --output text)  | grep GroupName

            "GroupName": "clusterdb-AccountingClusterClientSecurityGroup-C6X4N2MVV6SA",
            "GroupName": "onprem-HeadNodeSecurityGroup-1RHXOLSRP1F84",
```

There should be 2 groups. One is used to allow access to the Aurora database, the other is the standard security group for the headnode instance. We will retrieve the ID of the onprem group.

```bash
export ONPREM_SG=`aws ec2 describe-security-groups --group-ids $(aws ec2 describe-instances --instance-id $ONPREM_INSTANCEID --query "Reservations[].Instances[].SecurityGroups[].GroupId[]" --output text)  | grep GroupName | grep onprem | awk '{print $2}' | sed s/\"//g | sed s/,//g`
echo ${ONPREM_SG}
export CLOUD_SG=`aws ec2 describe-security-groups --group-ids $(aws ec2 describe-instances --instance-id $CLOUD_INSTANCEID --query "Reservations[].Instances[].SecurityGroups[].GroupId[]" --output text)  | grep GroupName | grep cloud | awk '{print $2}' | sed s/\"//g | sed s/,//g`
echo ${CLOUD_SG}

```

Now we will permit access between the headnodes by adding a new rule to the security group to allow other machines on the same VPC to communicate.

Now lets find out the CIDR range for the VPC.

```bash
export VPCCIDR=`aws ec2 describe-vpcs --filters Name=isDefault,Values=true --query "Vpcs[].CidrBlock" --region ${AWS_REGION} | jq -r '.[0]'`
echo ${VPCCIDR}
172.31.0.0/16
```

Next, lets add a new rule to the security groups to permit access from the VPC. 

```bash
aws ec2 authorize-security-group-ingress --group-name ${ONPREM_SG} --protocol all --cidr ${VPCCIDR}
{
    "Return": true,
    "SecurityGroupRules": [
        {
            "SecurityGroupRuleId": "sgr-1234567890",
            "GroupId": "sg-0123456789",
            "GroupOwnerId": "111111111111",
            "IsEgress": false,
            "IpProtocol": "-1",
            "FromPort": -1,
            "ToPort": -1,
            "CidrIpv4": "172.31.0.0/16"
        }
    ]
}
aws ec2 authorize-security-group-ingress --group-name ${CLOUD_SG} --protocol all --cidr ${VPCCIDR}
{
    "Return": true,
    "SecurityGroupRules": [
        {
            "SecurityGroupRuleId": "sgr-1234567890",
            "GroupId": "sg-0123456789",
            "GroupOwnerId": "111111111111",
            "IsEgress": false,
            "IpProtocol": "-1",
            "FromPort": -1,
            "ToPort": -1,
            "CidrIpv4": "172.31.0.0/16"
        }
    ]
}

```

Now the cloud cluster will be able to communicate with the onprem clusters SlurmDBD service. 
