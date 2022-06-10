+++
title = "c. Link S3 to FSx Lustre"
date = 2019-09-18T10:46:30-04:00
weight = 30
tags = ["configuration", "FSx", "ParallelCluster"]
+++

Now that we've created the filesystem we're going to link the filesystem to the cluster by creating a data repository association.

A [data repository association (DRA)](https://docs.aws.amazon.com/fsx/latest/LustreGuide/create-dra-linked-data-repo.html) imports metadata from the S3 bucket to the filesystem, making it appear as if the files in the S3 bucket exist on the filesystem. When you go to load a file it's fetched from S3 in the background and imported into the filesystem. If you want the filesystem to mirror the S3 bucket you can link it to the root of the filesystem `/`, like we do below. 

Next we're going to create a data repository association for the filesystem we created earlier:

```bash
aws fsx create-data-repository-association \
    --file-system-id $FSX_ID \
    --file-system-path / \
    --data-repository-path s3://mybucket-${BUCKET_POSTFIX} \
    --s3 AutoImportPolicy=\{"Events"=["NEW","CHANGED","DELETED"]\},AutoExportPolicy=\{"Events"=["NEW","CHANGED","DELETED"]\}
```

{{% notice info %}}
If you see the error: `Invalid choice: 'create-data-repository-association', maybe you meant: * create-data-repository-task`
Please follow the steps in [**Update the AWS CLI**](/02-aws-getting-started/05-start-aws-cli.html#update-the-aws-cli) to update the AWS CLI to version 2, then re-run the command.
{{% /notice %}}

This will give you a summary of the assocation:

```json
{
    "Association": {
        "AssociationId": "dra-02d711a4ea44d33af",
        "ResourceARN": "arn:aws:fsx:us-east-2:123456789:association/fs-123456789/dra-02d711a4ea44d33af",
        "FileSystemId": "fs-123456789",
        "Lifecycle": "CREATING",
        "FileSystemPath": "/",
        "DataRepositoryPath": "s3://mybucket-123456",
        "BatchImportMetaDataOnCreate": false,
        "ImportedFileChunkSize": 1024,
        "Tags": [],
        "CreationTime": "2022-06-15T21:37:46.657000+00:00"
    }
}
```