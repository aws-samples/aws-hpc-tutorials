+++
title = "d. Link S3 to FSx Lustre"
date = 2019-09-18T10:46:30-04:00
weight = 40
tags = ["configuration", "FSx", "ParallelCluster"]
+++

Now that we've created the filesystem we're going to link the filesystem to the cluster by creating a data repository association.

A [data repository association (DRA)](https://docs.aws.amazon.com/fsx/latest/LustreGuide/create-dra-linked-data-repo.html) imports metadata from the S3 bucket to the filesystem, making it appear as if the files in the S3 bucket exist on the filesystem. When you go to load a file it's fetched from S3 in the background and imported into the filesystem. If you want the filesystem to mirror the S3 bucket you can link it to the root of the filesystem `/`, like we do below.

First, let's grab the ID of the newly created filesystem. You'll need to wait for the stack to go into **CREATE_COMPLETE** before running the following command:

```bash
FSX_ID=$(aws cloudformation describe-stacks --stack-name hpc-cluster --query "Stacks[0].Outputs[?OutputKey=='FSXIds'].OutputValue" --output text)
```

Confirm that capturing the FSx file system ID worked, by echoing out the response.

```bash
echo $FSX_ID
```

If the output is `None` you will probably have to wait until the ParallelCluster 
If you don't see an ID like `fs-123456789`, check confirm the name of the cluster is `hpc-cluster` and the stack is in `CREATE_COMPLETE`.

Next we're going to create a data repository association. Note this can also be done from the [FSx Console](https://eu-west-1.console.aws.amazon.com/fsx/home?region=eu-west-1#file-systems) if you'd prefer a GUI approach.

```bash
aws fsx create-data-repository-association \
    --file-system-id $FSX_ID \
    --file-system-path / \
    --data-repository-path s3://mybucket-${BUCKET_POSTFIX} \
    --batch-import-meta-data-on-create \
    --s3 AutoImportPolicy=\{"Events"=["NEW","CHANGED","DELETED"]\},AutoExportPolicy=\{"Events"=["NEW","CHANGED","DELETED"]\}
```

This will give you a summary of the association:

```json
{
    "Association": {
        "AssociationId": "dra-05235cf3e4ba69a86",
        "ResourceARN": "arn:aws:fsx:eu-west-1:155423658722:association/fs-0c11cd01247483cfc/dra-05235cf3e4ba69a86",
        "FileSystemId": "fs-0c11cd01247483cfc",
        "Lifecycle": "CREATING",
        "FileSystemPath": "/",
        "DataRepositoryPath": "s3://mybucket-31251a58",
        "BatchImportMetaDataOnCreate": true,
        "ImportedFileChunkSize": 1024,
        "S3": {
            "AutoImportPolicy": {
                "Events": [
                    "NEW",
                    "CHANGED",
                    "DELETED"
                ]
            },
            "AutoExportPolicy": {
                "Events": [
                    "NEW",
                    "CHANGED",
                    "DELETED"
                ]
            }
        },
        "Tags": [],
        "CreationTime": "2023-05-08T13:57:34.495000+00:00"
    }
}
```

Creating the data repository association and syncing the metadata from the Amazon S3 bucket will take a few minutes. We can continue here, but might have to wait later in case the file system is not pre-populated with the objects from the Amazon S3 bucket.
