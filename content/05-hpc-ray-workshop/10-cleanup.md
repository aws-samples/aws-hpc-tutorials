---
title: "j. Cleanup"
date: 2022-08-27
weight: 110
---

Once our training is finished, we can cleanup all the resources. 

- Shutdown the cluster using the following command:

```bash
ray down -y cluster.yaml
```

- Navigate to the FSx console to deleted the filesystem. Select **ray-fsx** file system from the list, and click Actions button. From the dropdown, select Delete file system.

- Navigate to the EC2 console and click AMIs under Images in the left pan. Select ***ray_workshop_ami** from the list and click Actions button. From the dropdown, select Deregister AMI.
