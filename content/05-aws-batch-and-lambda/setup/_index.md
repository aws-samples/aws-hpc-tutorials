---
title : "b. Setup infrastructures"
weight : 20
---

{{% notice info %}}
This workshop requires an AWS Cloud9 IDE. Please complete the **[Preparation](/02-preparation.html)** section of the workshop if you have not done it. Getting familiar with AWS Batch by finishing **[AWS BATCH INTRODUCTION](/03-aws-batch-introductions.html)** is also recommended.
{{% /notice %}}

Let's download the archive that setup the basic infrastructure for this workshop. Four files including 2 shell scripts with commands and 2 YAML files to build infrastructure defined as code. 

```bash
mkdir -p fsi-demo/CloudFormation
cd fsi-demo
curl -o updateImage.sh https://raw.githubusercontent.com/aws-samples/aws-hpc-tutorials/batch/static/scripts/batch-lambda/updateImage.sh
curl -o buildArch.sh https://raw.githubusercontent.com/aws-samples/aws-hpc-tutorials/batch/static/scripts/batch-lambda/buildArch.sh
curl -o CloudFormation/fsi-demo-s3.yaml https://raw.githubusercontent.com/aws-samples/aws-hpc-tutorials/batch/static/scripts/batch-lambda/CloudFormation/fsi-demo-s3.yaml
curl -o CloudFormation/fsi-demo-batch.yaml https://raw.githubusercontent.com/aws-samples/aws-hpc-tutorials/batch/static/scripts/batch-lambda/CloudFormation/fsi-demo-batch.yaml
```
