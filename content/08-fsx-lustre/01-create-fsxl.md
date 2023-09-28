+++
title = "a. Create FSx for Lustre filesystem using AWS CLI"
date = 2019-09-18T10:46:30-04:00
weight = 80
tags = ["tutorial", "lustre", "FSx"]
+++

In this section, you will create a new FSx for lustre filesystem in your test account


1. Open your Cloud9 IDE terminal and go to your environment

```bash
cd ~/environment
```

2. Define a FSx Lustre Filesystem Name

```bash
export FSX_NAME="Lustre"
```

3. Obtain the Compute Security Group ID of of your cluster. 
```bash
export SG_ID=$(aws ec2 describe-security-groups --region ${AWS_REGION} --query "SecurityGroups[*].[GroupId]" --filters Name=group-name,Values=hpc-cluster-lab-Compute* --output text)
```

4. Set the VPC ID and Subnet ID by sourcing the **env_vars** script
```bash
source ~/environment/env_vars
```

5. Create the FSx Lustre Filesystem
```bash
export FSX_ID=$(aws fsx create-file-system \
    --file-system-type LUSTRE \
    --storage-capacity 1200 \
    --storage-type SSD \
    --subnet-ids ${SUBNET_ID} \
    --security-group-ids ${SG_ID} \
    --tags Key=Name,Value=${FSX_NAME} \
    --lustre-configuration DeploymentType="PERSISTENT_2",PerUnitStorageThroughput=125 \
    --region ${AWS_REGION} \
    --query "FileSystem.FileSystemId" \
    --output text)
```

6. Store the FSX ID in the **env_vars** script
```bash
echo "export FSX_ID=${FSX_ID}" >> ~/environment/env_vars
echo ${FSX_ID}
```

7. Check the status of of the FSx Lustre filesystem creation.

```bash
aws fsx --region ${AWS_REGION} describe-file-systems --file-system-ids ${FSX_ID} --query "FileSystems[0].Lifecycle" --output text
``` 

The status should be **CREATING**. Once created the status should be **AVAILABLE**. You can also check the Filesystem details and status in the [FSx console](https://console.aws.amazon.com/fsx/home).

{{% notice info %}}
Amazon FSx for Lustre file system creation will take **approximately 10 mins. In the meantime let us move to next steps**. 
{{% /notice %}}

