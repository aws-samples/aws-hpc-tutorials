+++
title = "j. Summary and Cleanup"
date = 2019-09-18T10:46:30-04:00
weight = 100
tags = ["tutorial", "FSx", "summary"]
+++


In this workshop, you learned how to create an Amazon FSx for Lustre partition with AWS ParallelCluster. Then, you learned how lazy file loading worked and conducted performance tests on the Lustre partition using IOR. Finally, you looked at the Lustre partition metrics and visualized these using Amazon CloudWatch.

Before moving to the next workshop, make sure to delete your cluster:

![Delete Cluster](/images/pcluster/pcmanager-delete.png)

Additionally, delete the filesystem we created on your [Cloud9](02-aws-getting-started/04-start_cloud9.html) instance:

```bash
aws fsx delete-file-system --file-system-id $FSX_ID
```

{{% notice info %}}
For more information on Amazon FSx for Lustre capabilities, see the [Amazon FSx for Lustre User Guide](https://docs.aws.amazon.com/fsx/latest/LustreGuide/what-is.html).
{{% /notice %}}

