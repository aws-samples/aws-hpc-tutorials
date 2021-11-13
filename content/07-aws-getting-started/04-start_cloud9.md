+++
title = "b. Create a Cloud9 Environment"
weight = 60
tags = ["tutorial", "cloud9", "ParallelCluster"]
+++
![Cloud 9](/images/hpc-aws-parallelcluster-workshop/cloud9.png)
[AWS Cloud9](https://aws.amazon.com/cloud9/) is a cloud-based integrated development environment (IDE) that lets you write, run, and debug your code with just a browser. This workshop uses Cloud9 to introduce you to the AWS Command Line Interface (AWS CLI) without the need to install any software on your laptop.

AWS Cloud9 contains a collection of tools that let you code, build, run, test, debug, and release software in the cloud using your internet browser. The IDE offers support for python, pip, AWS CLI, and provides easy access to AWS resources through Identity and Access Management (IAM) user credentials. The IDE includes a terminal with sudo privileges to the managed instance that is hosting your development environment and a pre-authenticated CLI. This makes it easy for you to quickly run commands and directly access AWS services.

{{% notice info %}}
After accessing your IDE, take a moment to familiarize yourself with the Cloud9 environment. For more information, follow a [tutorial](https://docs.aws.amazon.com/cloud9/latest/user-guide/tutorial.html#tutorial-tour-ide) or even view [Introduction to AWS Cloud9](https://www.youtube.com/watch?v=JDHZOGMMkj8).
{{% /notice %}}

#### Create Your Own AWS Cloud9 Instance {#section-2}

These steps apply to both individual users of this workshop and those in a group setting. To access your IDE, follow these steps:

1. In the AWS Management Console, locate **Cloud9** by using the search bar, or choose **Services**, then **Cloud9**.
![Cloud 9](/images/introductory-steps/cloud9-find.png)
2. Choose **Create Environment**
3. Name your environment **MyCloud9Env** and choose **Next Step**.
![Cloud 9](/images/introductory-steps/cloud9-name.png)
4. On the **Configure Settings** page, locate **Cost-saving setting** drop-down menu, and choose **After a day**. (Note: Your instructor may change other default selections.)
![Cloud 9](/images/introductory-steps/cloud9-defaults.png)
5. Choose **Next Step**.
6. Choose **Create Environment**.

Your AWS Cloud9 instance will be ready in a few minutes!

![Cloud9 Create](/images/introductory-steps/cloud9-create.png)
