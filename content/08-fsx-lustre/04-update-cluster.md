+++
title = "d. Mount the FSx Lustre Filesystem on the cluster"
date = 2019-09-18T10:46:30-04:00
weight = 110
tags = ["tutorial", "lustre", "FSx", "S3"]
+++


In this section you will update the cluster created in Lab I and  mount the filesystem created earlier in section a. of this lab. 

1. Go to your Cloud9 IDE terminal and run the below to obtain the FSx Lustre Filesystem ID

```bash
export FSX_ID=$(aws fsx describe-file-systems --query 'FileSystems[?FileSystemType == `LUSTRE`].{FileSystemId:FileSystemId}' --region $AWS_REGION --output text)
```

2. Update the **env_vars** file with the Filesystem ID (fs-xxx). 

```bash
echo "export FSX_ID=${FSX_ID}" >> env_vars
``` 
3. Source the **env_vars** and confirm the REGION and Filesystem ID are reported correctly. 

```bash
source env_vars

echo ${AWS_REGION}
echo ${FSX_ID}
```

3. Create a post-install script to mount the FSx Lustre Filesystem on the cluster.

```bash
# get filesystem information
export filesystem_id=${FSX_ID}
export filesystem_dns=$(aws fsx --region ${AWS_REGION} describe-file-systems --file-system-ids $filesystem_id --query "FileSystems[0].DNSName" --output text)
export filesystem_mountname=$(aws fsx --region ${AWS_REGION} describe-file-systems --file-system-ids $filesystem_id --query "FileSystems[].LustreConfiguration[].MountName" --output text)
```

```bash
cat > mount-fsx.sh << EOF
#!/bin/bash

# create mount dir
sudo mkdir -p /fsx

# mount filesystem
sudo mount -t lustre -o noatime,flock ${filesystem_dns}@tcp:/${filesystem_mountname} /fsx

EOF
```

4. Upload the post-install script to the previously created S3 bucket

```bash
aws s3 cp mount-fsx.sh s3://${BUCKET_NAME_DATA}
```

5. The cluster configuration file is in YAML format, so we will use a bash utility **yq** to update it

```bash
VERSION=v4.28.1
BINARY=yq_linux_amd64
sudo wget https://github.com/mikefarah/yq/releases/download/${VERSION}/${BINARY} -O $HOME/.local/bin/yq && sudo chmod +x $HOME/.local/bin/yq
```

6. Update cluster configuration file (**my-cluster-config.yaml**) with the post-install script and update the required policies. **Note that we are updating the compute queue and not the head node**

```bash
S3PATH=s3://${BUCKET_NAME_DATA}/mount-fsx.sh
S3PATH=$S3PATH yq -i '(.Scheduling.SlurmQueues[0].CustomActions.OnNodeConfigured.Script=env(S3PATH))' my-cluster-config.yaml   
```

```bash
yq -i '(.Scheduling.SlurmQueues[0].Iam.AdditionalIamPolicies[0]={"Policy": "arn:aws:iam::aws:policy/AmazonFSxFullAccess"})' my-cluster-config.yaml 
```

```bash
yq -i '(.Scheduling.SlurmQueues[0].Iam.AdditionalIamPolicies[1]={"Policy": "arn:aws:iam::aws:policy/AmazonS3FullAccess"})' my-cluster-config.yaml 
```

7. Update the cluster

```bash
pcluster update-compute-fleet -n hpc-cluster-lab --status STOP_REQUESTED --region ${AWS_REGION}
```

Wait for the compute fleet to be stopped before updating the cluster.

```bash
pcluster update-cluster -n hpc-cluster-lab -c my-cluster-config.yaml --region ${AWS_REGION} --suppress-validators ALL
```

Wait for the cluster to be updated. You can check the cluster update status with `pcluster list-clusters -r ${AWS_REGION}` or monitoring the CloudFormation stack in the AWS Console.

Re-start the compute fleet


```bash
pcluster update-compute-fleet -n hpc-cluster-lab --status START_REQUESTED --region ${AWS_REGION}
```


You have now successfully mounted the created Lustre filesystem on the cluster. In the next section, you will monitor the Filesystem and learn more about the HSM capabilities between FSx Lustre and Amazon S3.

