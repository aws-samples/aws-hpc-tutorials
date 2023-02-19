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

2. Update cluster configuration file (**my-cluster-config.yaml**) with the post-install script and update the required policies.

```bash
cat <<EOF>> my-cluster-config.yaml
SharedStorage:
- MountDir: /fsx
  Name: Lustre
  StorageType: FsxLustre
    FileSystemId: ${FSX_ID}
```

3. Update the cluster

```bash
pcluster update-cluster -n hpc-cluster-lab -c my-cluster-config.yaml --region ${AWS_REGION} --suppress-validators ALL
```

4. Wait for the cluster to be updated. You can check the cluster update status as below or monitoring the CloudFormation stack in the AWS Console.

```bash
pcluster describe-cluster -n hpc-cluster-lab --query clusterStatus --region ${AWS_REGION}
```

Once the cluster is updated, you will see a **UPDATE_COMPLETE** status.

5. You need to re-start the compute fleet.  You will use the **update-compute-fleet** command to do this:

```bash
pcluster update-compute-fleet -n hpc-cluster-lab --status START_REQUESTED --region ${AWS_REGION}
```

6. Check the status of the compute fleet.

```bash
pcluster describe-compute-fleet -n hpc-cluster-lab --query status --region ${AWS_REGION}
```

You should see a **RUNNING** status after re-starting the compute fleet.


You have now successfully mounted the created Lustre filesystem on the cluster. In the next section, you will monitor the Filesystem and learn more about the HSM capabilities between FSx Lustre and Amazon S3.

