+++
title = "c. Connect to your NICE DCV Session"
date = 2019-09-18T10:46:30-04:00
weight = 80
tags = ["tutorial", "NICE DCV", "ParallelCluster", "Remote Desktop"]

+++

{{% notice tip %}}
The `pcluster dcv connect` command interacts with the NICE DCV server running on the master instance. When you run this command to connect to your DCV cluster, you will get a browser URL which expires 30 seconds after it is issued. If the connection is not made before the URL expires, run `pcluster dcv connect` again to generate a new URL
{{% /notice %}}

To connect to your NICE DCV session, simply run the following command in your AWS Cloud9 Terminal: 

`pcluster dcv connect [cluster] -k [keyname]`

where [cluster] specifies the name of your cluster and [keyname] specifies the location of your private key. 


```bash
pcluster dcv connect my-dcv-cluster -k ~/.ssh/lab-dcv-key
```
You will get a browser URL to connect to the NICE DCV session running on the master instance, copy and paste the URL in your browser

See example video below

<video autoplay ="autoplay" loop="loop" preload="auto" width="640" height="240" controls>
  <source src="/images/nice-dcv/pc-dcv-connect.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>

Now that you can successfully connect to your NICE DCV session and open a terminal, you can next run a test application and visualize output.

To run the DCV Test GL application, Go to **Applications** → **Other** → **DCV GL Test Application**
![DCV Connect](/images/nice-dcv/Connect-DCV-StartGL.png)

You should see this:
![DCV Connect](/images/nice-dcv/Connect-DCV-ViewGL.png)


{{% notice tip %}}
NICE DCV Licensing: The NICE DCV server does not require a license server when running on Amazon EC2 instances. However, the NICE DCV server must periodically connect to an Amazon S3 bucket to determine whether a valid license is available.
AWS ParallelCluster automatically adds the required permissions to the [ParallelClusterInstancePolicy](https://docs.aws.amazon.com/parallelcluster/latest/ug/iam.html#parallelclusterinstancepolicy), so the user does not need to do anything.
{{% /notice %}}

