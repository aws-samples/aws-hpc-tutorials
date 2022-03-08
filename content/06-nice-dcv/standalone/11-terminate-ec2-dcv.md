+++
title = "d. Terminate Your Instance"
date = 2019-09-18T10:46:30-04:00
weight = 200
tags = ["HPC", "NICE", "Visualization", "Remote Desktop", "Web Browser", "Native Client"]
+++

Now that you are done with your NICE DCV EC2 instance, we can terminate it from the EC2 Dashboard as shown below:

Go to [**EC2 Console**](https://console.aws.amazon.com/ec2), select your NICE DCV EC2 instance, click on **Instance state** -> **Terminate instance**
![DCV Terminate](/images/nice-dcv/Terminate-DCV-EC2.png)


Confirm by clicking, **Terminate**.

Now that you are done with your NICE DCV EC2 workshop. We can delete the instance profile created in previous steps, with the following command:
```bash
aws cloudformation delete-stack --stack-name DCVInstanceProfile
```

With this, we clean up all the AWS resources related to this NICE DCV workshop.



