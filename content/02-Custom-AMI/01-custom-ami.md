---
title: "a. Deep Learning AMI"
weight: 21
tags: ["tutorial", "cloud9", "ParallelCluster"]
---

![DL AMI Logo](/images/01-getting-started/dlami.jpeg)

This section documents how to build a ParallelCluster AMI based on the [Deep Learning Ubuntu 20.04 AMI](https://aws.amazon.com/releasenotes/aws-deep-learning-base-gpu-ami-ubuntu-20-04/). This means we'll take an ami that's pre-built with [PyTorch](https://docs.aws.amazon.com/dlami/latest/devguide/tutorial-pytorch.html), CUDA, NCCL and EFA and then build on top the parallelcluster components like Slurm, Lustre, ect.

We recommend this approach over taking a AWS ParallelCluster AMI and customizing it as it can be complicated and error prone to install the CUDA stack. This approach relies on the pre-built stack in the Deep Learning AMI, skipping all that.

#### 1 - Grab AMI ID

1. Find the name of the AMI that you'd like to use from the [release notes](https://docs.aws.amazon.com/dlami/latest/devguide/appendix-ami-release-notes.html) page. If you're unsure the following command will use the **AWS Deep Learning Base GPU AMI (Ubuntu 20.04)** which is a good ami to start with.

2. Next run the following command with the **Name** substituted for the ami you want. i.e. `Deep Learning Base GPU AMI (Ubuntu 20.04) ????????`:

    ```bash
    aws ec2 describe-images --region us-east-1 --owners amazon --filters 'Name=name,Values=Deep Learning Base GPU AMI (Ubuntu 20.04) ????????' 'Name=state,Values=available' --query 'reverse(sort_by(Images, &CreationDate))[:1].ImageId' --output text

    ```

    You'll get an ami id like `ami-0528af10692058c25`.

#### 2 - Create a ParallelCluster AMI

1. Next using the ami id we fetched, we'll create a config file `dl-ami.yaml` like so:

    ```yaml
    Build:
      InstanceType: g4dn.2xlarge
      ParentImage: ami-0528af10692058c25
    ```

2. Then run the `pcluster build-image` command and specify that config file.

    ```bash
    pcluster build-image --image-id pcluster-3-5-0-deep-learning-alinux2 -c dl-ami.yaml
    ```

{{% notice note %}}
Think of the flag `--image-id` as the name of the image. In the above example we call it `pcluster-3-7-0-deep-learning-ubuntu` to easily see which version of parallelcluster we built the image for and the framework/os. Feel free to change this to suit your use case.
{{% /notice %}}

#### 3 - Grab the ParallelCluster AMI

Once the image is finished building you'll see in `pcluster list-images`

```bash
$ pcluster list-images --image-status AVAILABLE
{
  "images": [
    {
      "imageId": "pcluster-3-7-0-deep-learning-ubuntu",
      "imageBuildStatus": "BUILD_COMPLETE",
      "ec2AmiInfo": {
        "amiId": "ami-1234abcd5678efgh"
      },
      "region": "us-east-1",
      "version": "3.7.0"
    }
  ]
}
```
