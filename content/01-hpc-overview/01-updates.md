---
title: "Updates"
date: 2022-09-29T14:41:06Z
draft: false
weight: 20
---

{{% notice info  %}}
Frequently asked questions will be addressed on this page during the tutorial. Do not hesitate to visit this page often during the tutorial!
{{% /notice %}}

#### Accounts access

Sandbox are available on {{< param tutorialDate >}} for the duration of the tutorial. If you would like to run through the labs at a later stage on your own, with your company or institution, please contact us at sc22tutorial@amazon.com so we can follow-up with you.

#### Check if your are on AWS Cloud9 or the head node of the HPC Cluster

If you can't run one of the commands of the tutorial, please ensure that you are running on AWS Cloud9. If in doubt you can run the command below.

```bash
if [ -d /etc/parallelcluster/ ]; then exit; fi
```
