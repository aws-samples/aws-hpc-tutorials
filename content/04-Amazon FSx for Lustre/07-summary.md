+++
title = "g. Summary and Cleanup"
date = 2019-09-18T10:46:30-04:00
weight = 80
tags = ["tutorial", "FSx", "summary"]
+++


In this workshop, you learned how to create an Amazon FSx for Lustre partition with AWS ParallelCluster. Then, you learned how lazy file loading worked and conducted performance tests on the Lustre partition using IOR. Finally, you looked at the Lustre partition metrics and visualized these using Amazon CloudWatch.

Before moving to the next workshop, make sure to delete your cluster using the following command:

```bash
pcluster delete-cluster --cluster-name my-fsx-cluster
```

{{% notice info %}}
For more information on Amazon FSx for Lustre capabilities, see the [Amazon FSx for Lustre User Guide](https://docs.aws.amazon.com/fsx/latest/LustreGuide/what-is.html).
{{% /notice %}}

