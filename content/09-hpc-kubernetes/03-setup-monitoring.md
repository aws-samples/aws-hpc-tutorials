+++
title = "c. Setup monitoring"
date = 2022-09-28T10:46:30-04:00
weight = 80
tags = ["tutorial", "hpc", "Kubernetes"]
+++

In this section, you will lean how to interactively watch the running pods in your cluster as well as monitor the CPU utilization of your nodes.


1. Deploy `htop` daemonset

We will use `htop` pods running on each node to interactively monitor CPU utilization.

Copy the daemonset manifest below into a file named `htop-daemonset.yaml`

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: htop
  namespace: gromacs
spec:
  selector:
    matchLabels:
      name: htop
  template:
    metadata:
      labels:
        name: htop
    spec:
      containers:
        - name: htop
          image: terencewestphal/htop:latest
          command: ["/bin/sh"]
          args: ["-c", "while true; do date; sleep 10; done"]
```

Then apply the daemonset manifest

```bash
kubectl apply -f ./htop-daemonset.yaml
```

2. Monitor running pods

Open a new terminal window and execute the following command to watch the running pods in the `gromacs` namespace:

```bash
watch kubectl -n gromacs get pods -o wide
```

You should see the htop pods running on each of the nodes

3. Monitor CPU utilization

Open two new terminal windows. 

In the first terminal window open a shell into the first htop pod.

```bash
kubectl -n gromacs exec -it $(kubectl -n gromacs get pods | grep htop | head -n 1 | cut -d ' ' -f 1) -- sh
```

In the second terminal window open a shell into the second htop pod.

```bash
kubectl -n gromacs exec -it $(kubectl -n gromacs get pods | grep htop | head -n 2 | cut -d ' ' -f 1) -- sh
```

In each of the pod shells execute the command `htop`

4. Arrange terminals

At this point you should have four terminals open. Use drag and drop to arrange them in a way that allows you to see all of them at the same time. A recommended layout is shown below.

![Interactive Monitoring](/images/aws-eks/interactive-monitoring.png)
