+++
title = "d. Mount the FSx Lustre Filesystem on the cluster"
date = 2019-09-18T10:46:30-04:00
weight = 110
tags = ["tutorial", "lustre", "FSx", "S3"]
+++


In this section you will update the cluster created in Lab I and  mount the filesystem created earlier in section a. of this lab.

1. Go to your Cloud9 IDE terminal and run the **env_vars** if not done already.

```bash
source ~/environment/env_vars
```

2. Create a post-install script to mount the FSx Lustre Filesystem on the cluster.

```bash
export filesystem_id=${FSX_ID}
export filesystem_dns=$(aws fsx --region ${AWS_REGION} describe-file-systems --file-system-ids $filesystem_id --query "FileSystems[0].DNSName" --output text)
export filesystem_mountname=$(aws fsx --region ${AWS_REGION} describe-file-systems --file-system-ids $filesystem_id --query "FileSystems[].LustreConfiguration[].MountName" --output text)
```

```bash
cat > mount-fsx.sh << EOF
#!/bin/bash

sudo mkdir -p /fsx

sudo mount -t lustre -o noatime,flock ${filesystem_dns}@tcp:/${filesystem_mountname} /fsx

EOF
```

3. Upload the post-install script to the previously created S3 bucket

```bash
aws s3 cp mount-fsx.sh s3://${BUCKET_NAME_DATA}
```

4. Stop the compute fleet

```bash
pcluster update-compute-fleet -n hpc-cluster-lab --status STOP_REQUESTED --region ${AWS_REGION}
```  

5. Update cluster configuration file (**my-cluster-config.yaml**) with the post-install script and update the required policies. **Note that we are updating the compute queue and not the head node**

```bash
export S3PATH=s3://${BUCKET_NAME_DATA}/mount-fsx.sh
yq -i '(.Scheduling.SlurmQueues[0].CustomActions.OnNodeConfigured.Script=env(S3PATH)) |
       (.Scheduling.SlurmQueues[0].Iam.AdditionalIamPolicies[0]={"Policy": "arn:aws:iam::aws:policy/AmazonFSxFullAccess"}) |
       (.Scheduling.SlurmQueues[0].Iam.AdditionalIamPolicies[1]={"Policy": "arn:aws:iam::aws:policy/AmazonS3FullAccess"})' ~/environment/my-cluster-config.yaml
```

6. Update the cluster

```bash
pcluster update-cluster -n hpc-cluster-lab -c my-cluster-config.yaml --region ${AWS_REGION} --suppress-validators ALL
```

7. Wait for the cluster to be updated. You can check the cluster update status as below or monitoring the CloudFormation stack in the AWS Console.

```bash
pcluster describe-cluster -n hpc-cluster-lab --query clusterStatus --region ${AWS_REGION}
```

Once the cluster is updated, you will see a **UPDATE_COMPLETE** status.

8. Start the compute fleet

```bash
pcluster update-compute-fleet -n hpc-cluster-lab --status START_REQUESTED --region ${AWS_REGION}
```

9. Check the status of the compute fleet.

```bash
pcluster describe-compute-fleet -n hpc-cluster-lab --query status --region ${AWS_REGION}
```

You should see a **RUNNING** status after re-starting the compute fleet.


You have now successfully mounted the created Lustre filesystem on the cluster. In the next section, you will monitor the Filesystem and learn more about the HSM capabilities between FSx Lustre and Amazon S3.

