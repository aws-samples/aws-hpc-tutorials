+++
title = "Setup the environment"
date = 2023-04-10T10:46:30-04:00
weight = 25
tags = ["tutorial", "ParallelCluster"]
+++

{{% notice info %}}This lab requires some infrastructure to be setup prior to starting. Setting up everything ready will typically take 40-60 minutes. We recommend running the setup over lunch or a break.
{{% /notice %}}

Please download the following script and run it in a terminal inside your Cloud 9 Instance. If you are attending an AWS event, a Cloud9 instance will be provisioned for you. If you are following these instructions on your own, then please Start a Cloud9 instance and assign the instance Admin rights. If necessary refer to [Cloud9 setup]({{< ref "/07-aws-getting-started/02-requirement_notes.html" >}})

```bash
wget --user isc23 --password computer https://isc23.hpcworkshops.com/scripts/federation-and-cache/workshop-setup.sh
chmod 755 workshop-setup.sh
./workshop-setup.sh | tee setup.log
```

The script will take some time to run, when it is finished the message "Setup Complete." will be displayed.

Incase of any problems, please refer to the log file or ask. The next page includes a few checks that the automatino has worked correctly.