+++
title = "f. Remove NICE DCV Licensing"
date = 2019-09-18T10:46:30-04:00
weight = 200
tags = ["HPC", "NICE", "Visualization", "Remote Desktop", "Web Browser", "Native Client"]
+++

Now that you are done with your NICE DCV EC2 workshop. We can delete the instance profile created in previous steps, with the following command:
```bash
aws cloudformation delete-stack --stack-name DCVWorkshop
```

With this, we successfully clean up all the AWS resources related to this NICE DCV workshop.