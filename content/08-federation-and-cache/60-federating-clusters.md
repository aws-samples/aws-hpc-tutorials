+++
title = "Federating the clusters"
date = 2023-04-10T10:46:30-04:00
weight = 60
tags = ["tutorial", "ParallelCluster", "Manager"]
+++

{{% notice warning %}} Log out of the cluster and return to the Cloud9 instance. {{% /notice %}}

To federate the two clusters we need to attach them both to the same SlurmDBD service. In this example we will attach the cloud cluster to the SlurmDBD running in on the onprem cluster. 

Before we can reconfigure the cluster we need to open the security group on the onprem head so it will accept connections from the cloud headnode.

First lets get the instance ID for the onprem headnode. Ensure you are logged into the Cloud 9 instance, not the cluster.

```bash
export ONPREM_INSTANCEID=`pcluster describe-cluster -n onprem -r eu-west-1 | jq '.headNode.instanceId' | sed s/\"//g`
echo $ONPREM_INSTANCEID
i-0142d727aaced581c
```

Now lets see which security groups are attached to the onprem headnode.

```bash
aws ec2 describe-security-groups --group-ids $(aws ec2 describe-instances --instance-id $ONPREM_INSTANCEID --query "Reservations[].Instances[].SecurityGroups[].GroupId[]" --output text)  | grep GroupName

            "GroupName": "clusterdb-AccountingClusterClientSecurityGroup-C6X4N2MVV6SA",
            "GroupName": "onprem-HeadNodeSecurityGroup-1RHXOLSRP1F84",
```

There should be 2 groups. One is used to allow access to the Aurora database, the other is the standard security group for the headnode instance. We will retrieve the ID of the onprem group.

```bash
export ONPREM_SG=`aws ec2 describe-security-groups --group-ids $(aws ec2 describe-instances --instance-id $ONPREM_INSTANCEID --query "Reservations[].Instances[].SecurityGroups[].GroupId[]" --output text)  | grep GroupName | grep onprem | awk '{print $2}' | sed s/\"//g | sed s/,//g`
echo ${ONPREM_SG}
```

Now we will premit access to the onprem headnode by adding a new rule to the security group to allow other machines on the same VPC to communicate with the headnode on port 6819

Now lets find out the CIDR range for the VPC.

```bash
export VPCCIDR=`aws ec2 describe-vpcs --filters Name=isDefault,Values=true --query "Vpcs[].CidrBlock" --region ${AWS_REGION} | jq -r '.[0]'`
echo ${VPCCIDR}
172.31.0.0/16
```

Next, lets add a new rule to the security group to permit access from the VPC. In this lab, to keep things simple, we will allow access from the whole VPC. In a production setting you might want to limit this more, maybe to the specific instance.

```bash
aws ec2 authorize-security-group-ingress --group-name ${ONPREM_SG} --protocol tcp --port 6819 --cidr ${VPCCIDR}
{
    "Return": true,
    "SecurityGroupRules": [
        {
            "SecurityGroupRuleId": "sgr-07e51b3f431c6f753",
            "GroupId": "sg-0cd67f9f23ea13239",
            "GroupOwnerId": "196438911214",
            "IsEgress": false,
            "IpProtocol": "tcp",
            "FromPort": 6819,
            "ToPort": 6819,
            "CidrIpv4": "172.31.0.0/16"
        }
    ]
}
```

Now the cloud cluster will be able to communicate with the onprem clusters SlurmDBD service. 
