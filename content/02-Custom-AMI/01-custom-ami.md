---
title: "a. Build Custom AMI for ParallelCluster"
weight: 21
tags: ["tutorial", "cloud9", "ParallelCluster"]
---

#### 1 - Grab AMI ID

1. Find the name of the AMI that you'd like to use from the [release notes](https://docs.aws.amazon.com/dlami/latest/devguide/appendix-ami-release-notes.html) page. If you're unsure the following command will use the **multi-framework deep learning amazon linux 2 ami** which is a good ami to start with.
2. Next run the following command with the **Name** substituted for the ami you want. i.e. `Deep Learning AMI (Amazon Linux 2) Version ??.?`:

    ```bash
    aws ec2 describe-images --region us-east-1 --owners amazon --filters 'Name=name,Values=Deep Learning AMI (Amazon Linux 2) Version ??.?' 'Name=state,Values=available' --query 'reverse(sort_by(Images, &CreationDate))[:1].ImageId' --output text
    ```

    You'll get an ami id like `ami-0528af10692058c25`.

#### 2 - Create a ParallelCluster AMI

Next using the ami id we fetched, we'll create a config file `dl-ami.yaml` like so:

```yaml
Build:
  InstanceType: p4d.24xlarge
  ParentImage: ami-0528af10692058c25
```

Then run the `pcluster build-image` command and specify that config file.

```bash
pcluster build-image --image-id pcluster-3-5-0-deep-learning-alinux2 -c dl-ami.yaml
```

{{% notice note %}}
Think of the flag `--image-id` as the name of the image. In the above example we call it `pcluster-3-5-0-deep-learning-alinux2` to easily see which version of parallelcluster we built the image for and the framework/os. Feel free to change this to suit your use case.
{{% /notice %}}

#### 3 - Grab the ParallelCluster AMI

Once the image is finished building you'll see it under **Images**

```bash
$ pcluster list-images --image-status ALL
{
  "images": [
    {
      "imageId": "pcluster-3-5-0-deep-learning-alinux2",
      "imageBuildStatus": "BUILD_COMPLETE",
      "ec2AmiInfo": {
        "amiId": "ami-1234abcd5678efgh"
      },
      "region": "us-east-1",
      "version": "3.5.0"
    }
  ]
}
```
