+++
title = "c. Connect to your NICE DCV Session"
date = 2019-09-18T10:46:30-04:00
weight = 80
tags = ["tutorial", "NICE DCV", "ParallelCluster", "Remote Desktop"]

+++

{{% notice tip %}}
The `pcluster dcv-connect` command interacts with the NICE DCV server running on the master instance. When you run this command to connect to your DCV cluster, you will get a browser URL which expires 30 seconds after it is issued. If the connection is not made before the URL expires, run `pcluster dcv-connect` again to generate a new URL
{{% /notice %}}

To connect to your NICE DCV session, simply run the following command in your AWS Cloud9 Terminal: 

`pcluster dcv-connect -n [cluster] --key-path [keyname]`

where [cluster] specifies the name of your cluster and [keyname] specifies the location of your private key. 


```bash
pcluster dcv-connect -n my-dcv-cluster --key-path ${AWS_KEYPAIR}.pem
```
You will get a browser URL to connect to the NICE DCV session running on the master instance, copy and paste the URL in your browser

See example video below

<video autoplay ="autoplay" loop="loop" preload="auto" width="640" height="240" controls>
  <source src="/images/nice-dcv/pc-dcv-connect.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>

Note: If you are using Firefox, you might have a warning because of the self-signed certificate. If this is the case, you can simply bypass this by clicking on **Advanced** and then **Accept the Risk and Continue**.


Now that you can successfully connect to your NICE DCV session and open a terminal, you can next run a test application and visualize output.

In the current version of ParallelCluster, the DCV Test GL application that we want to run might not be available. Check if it is available by going to **Applications** → **Other** → **DCV GL Test Application**
![DCV Connect](/images/nice-dcv/Connect-DCV-StartGL.png)

If you have the application, run it. You should see this:
![DCV Connect](/images/nice-dcv/Connect-DCV-ViewGL.png)

If the application is not available, go back to your Cloud9 environment and paste the following command in your terminal to connect to the master of your cluster:

```bash
pcluster ssh --cluster-name my-dcv-cluster -i ${AWS_KEYPAIR}.pem
```

You can now paste the following commands:

```bash
cat > ./install_dcv_gltest.sh << EOF
#!/bin/bash
set -e # exit on error

# install dcvgltest
sudo rpm --import https://d1uj6qtbmh3dt5.cloudfront.net/NICE-GPG-KEY
wget https://d1uj6qtbmh3dt5.cloudfront.net/2020.0/Servers/nice-dcv-2020.0-8428-el7.tgz
tar -xvzf nice-dcv-2020.0-8428-el7.tgz
cd nice-dcv-2020.0-8428-el7
sudo yum install nice-dcv-gltest-2020.0.229-1.el7.x86_64.rpm
EOF
```

This is a simple script to install the DCV Test GL application. If something does not work, please refer to the [DCV installation tutorial](https://docs.aws.amazon.com/dcv/latest/adminguide/setting-up-installing-linux-server.html#amazon-linux-2,-rhel-7.x,-and-centos-7.x) (steps 1 through 5 and then install the nice-dcv-gltest package).
Paste this into your terminal to launch the installation script:

```bash
chmod +x ./install_dcv_gltest.sh
./install_dcv_gltest.sh
```

You are now able to launch the DCV Test GL application as explained earlier.


{{% notice tip %}}
NICE DCV Licensing: The NICE DCV server does not require a license server when running on Amazon EC2 instances. However, the NICE DCV server must periodically connect to an Amazon S3 bucket to determine whether a valid license is available.
AWS ParallelCluster automatically adds the [required permissions](https://docs.aws.amazon.com/parallelcluster/latest/ug/iam-roles-in-parallelcluster-v3.html) to the instance, so the user does not need to do anything.
{{% /notice %}}

