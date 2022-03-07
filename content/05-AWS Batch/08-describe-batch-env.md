+++
title = "h. Describe Your Environment"
date = 2019-09-18T10:46:30-04:00
weight = 90
tags = ["tutorial", "install", "AWS", "batch", "Docker"]
+++

Now that you have configured AWS Batch, you can take inspect your newly created environment by issuing each of the following commands. Note that they each return a paginated environment where you can use the arrow keys to scroll up and down and enter 'q' to quit.

```bash
aws batch describe-compute-environments
```

```bash
aws batch describe-job-queues
```

```bash
aws batch describe-job-definitions
```

You will see that the *JSON* documents returned in response to each of these commands contain the parameters that you specified when you set up the **compute environment**, **job queue**, and **job definition**. Keep in mind that the steps that you have completed up to this point using the AWS Management Console can also be accomplished using the AWS CLI, AWS SDK, or AWS CloudFormation. This output represents the definition of your AWS Batch compute infrastructure, illustrating the concept of *infrastructure as code*. 

