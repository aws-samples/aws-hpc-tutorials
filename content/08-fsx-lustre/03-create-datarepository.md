+++
title = "c. Create data repository association between S3 and FSx for Lustre"
date = 2019-09-18T10:46:30-04:00
weight = 100
tags = ["tutorial", "lustre", "FSx", "S3"]
+++

In this step, you will create a [Data Repository Association](https://docs.aws.amazon.com/fsx/latest/LustreGuide/create-dra-linked-data-repo.html) (DRA) between the S3 bucket and FSx Lustre Filesystem.

1. Navigate to your Cloud9 IDE and on the Cloud9 terminal. Ensure you have sourced the **env_vars** script

```bash
source ~/environment/env_vars
```  

2. Now you will create a data repository association between your S3 bucket (created in step b.) and your FSx Lustre Filesystem (created in step a.) of this lab. Before doing this please confirm that your FSx Lustre Filesystem is created and AVAILABLE from Step a.

```bash
aws fsx create-data-repository-association \
    --file-system-id ${FSX_ID} \
    --file-system-path "/hsmtest" \
    --data-repository-path s3://${BUCKET_NAME_DATA} \
    --s3 AutoImportPolicy='{Events=[NEW,CHANGED,DELETED]},AutoExportPolicy={Events=[NEW,CHANGED,DELETED]}' \
    --region ${AWS_REGION}
``` 

3. You can query the status of the data repsository association creation as below

```bash
aws fsx describe-data-repository-associations --filters "Name=file-system-id,Values=${FSX_ID}" --query "Associations[0].Lifecycle" --output text
```
The status should be **CREATING**. Once created the status should be **AVAILABLE**. You can also check the Data repository association details and status in the [FSx console](https://console.aws.amazon.com/fsx/home) by clicking on your File System ID.

![datarepotab](/images/fsx-for-lustre-hsm/datarepotab.png)

![dracreating](/images/fsx-for-lustre-hsm/dracreating.png)

{{% notice info %}}
Step 3 is expected to take a few  minutes. You are going to check this again and you can proceed with the next section. While creating you should be able to see the status as shown above. 
{{% notice info %}}


