+++
title = "a. Connect to your NICE DCV Session"
date = 2019-09-18T10:46:30-04:00
weight = 80
tags = ["tutorial", "NICE DCV", "ParallelCluster", "Remote Desktop"]

+++

First connect to your cluster using DCV following the instructions in [**b. Connect to the Cluster**](/05-create-cluster/02-connect-cluster.html#dcv-connect).

Now we can install a simple application called **DCV Test GL** . If something does not work, please refer to the [DCV installation tutorial](https://docs.aws.amazon.com/dcv/latest/adminguide/setting-up-installing-linux-server.html#amazon-linux-2,-rhel-7.x,-and-centos-7.x) (steps 1 through 5 and then install the nice-dcv-gltest package).
Paste this into your terminal to install:

```bash
# install dcvgltest
sudo rpm --import https://d1uj6qtbmh3dt5.cloudfront.net/NICE-GPG-KEY
wget https://d1uj6qtbmh3dt5.cloudfront.net/2020.0/Servers/nice-dcv-2020.0-8428-el7.tgz
tar -xvzf nice-dcv-2020.0-8428-el7.tgz
cd nice-dcv-2020.0-8428-el7
sudo yum install nice-dcv-gltest-2020.0.229-1.el7.x86_64.rpm
```

Next launch the appication by clicking **Activities** > **Apps** > **DCV GL**

![DCV Connect](/images/nice-dcv/Connect-DCV-StartGL.png)

You should then see the following:

![DCV Connect](/images/nice-dcv/Connect-DCV-ViewGL.png)

{{% notice tip %}}
NICE DCV Licensing: The NICE DCV server does not require a license server when running on Amazon EC2 instances. However, the NICE DCV server must periodically connect to an Amazon S3 bucket to determine whether a valid license is available.
AWS ParallelCluster automatically adds the [required permissions](https://docs.aws.amazon.com/parallelcluster/latest/ug/iam-roles-in-parallelcluster-v3.html) to the instance, so the user does not need to do anything.
{{% /notice %}}

