+++
title = "g. Run Gromacs MPI job"
date = 2022-09-28T10:46:30-04:00
weight = 70
tags = ["tutorial", "hpc", "Kubernetes"]
+++

In this section, you will run a Gromacs MPI job distributed between two c5n.18xlarge nodes in your Kubernetes cluster.

####  1. Create MPIJob manifest

Copy the MPIJob manifest below into a file named `gromacs-mpi.yaml`, 

```bash
cat > ~/environment/gromacs-mpi.yaml << EOF
apiVersion: kubeflow.org/v2beta1
kind: MPIJob
metadata:
  name: gromacs-mpi
  namespace: gromacs
spec:
  slotsPerWorker: 36
  runPolicy:
    cleanPodPolicy: Running
  mpiReplicaSpecs:
    Launcher:
      replicas: 1
      template:
         spec:
          restartPolicy: OnFailure
          volumes:
          - name: cache-volume
            emptyDir:
              medium: Memory
              sizeLimit: 2048Mi
          - name: data
            persistentVolumeClaim:
              claimName: fsx-pvc
          initContainers:
          - image: "${IMAGE_URI}"
            name: init
            command: ["sh", "-c", "cp /inputs/* /data; sleep 5"]
            volumeMounts:
            - name: data
              mountPath: /data
          containers:
          - image: "${IMAGE_URI}"
            imagePullPolicy: Always
            name: gromacs-mpi-launcher
            volumeMounts:
            - name: cache-volume
              mountPath: /dev/shm
            - name: data
              mountPath: /data
            env:
            - name: OMPI_MCA_verbose
              value: "1"
            command:
            - /opt/view/bin/mpirun
            - --allow-run-as-root
            - --oversubscribe
            - -x
            - FI_LOG_LEVEL=info
            - -x
            - FI_PROVIDER=efa
            - -np
            - "72"
            - -npernode
            - "36"
            - --bind-to
            - "core"
            - -x
            - OMPI_MCA_verbose
            - -x
            - OMP_NUM_THREADS
            - /opt/view/bin/gmx_mpi
            - mdrun
            - -ntomp
            - "1"
            - -deffnm
            - "/data/md_0_1"
            - -s
            - "/data/md_0_1.tpr"
    Worker:
      replicas: 2
      template:
        spec:
          volumes:
          - name: cache-volume
            emptyDir:
              medium: Memory
              sizeLimit: 2048Mi
          - name: data
            persistentVolumeClaim:
              claimName: fsx-pvc
          containers:
          - image: "${IMAGE_URI}"
            imagePullPolicy: Always
            name: gromacs-mpi-worker
            volumeMounts:
            - name: cache-volume
              mountPath: /dev/shm
            - name: data
              mountPath: /data
            resources:
              limits:
                hugepages-2Mi: 5120Mi
                vpc.amazonaws.com/efa: 1
                memory: 8000Mi
              requests:
                hugepages-2Mi: 5120Mi
                vpc.amazonaws.com/efa: 1
                memory: 8000Mi
EOF
```

####  2. Run the Gromacs MPIJob

```bash
kubectl apply -f ./gromacs-mpi.yaml
```

Follow the launcher logs as soon as the pod enters the Running state

```bash
kubectl -n gromacs logs -f $(kubectl -n gromacs get pods | grep gromacs-mpi-launcher | head -n 1 | cut -d ' ' -f 1)
```

You should see libfabric log entries similar to the shown below. Together with the launcher pod in status Running and increased utilization of the cluster node cores, this is an indication that the MPI Job is in progress.

```log
libfabric:64:1664512976:efa:mr:ofi_mr_cache_cleanup():466<info> MR cache stats: searches 0, deletes 0, hits 0 notify 158
libfabric:28:1664512976:efa:mr:ofi_mr_cache_cleanup():466<info> MR cache stats: searches 49683, deletes 49683, hits 49679 notify 142
libfabric:27:1664512976:efa:mr:ofi_mr_cache_cleanup():466<info> MR cache stats: searches 2, deletes 2, hits 0 notify 142
libfabric:21:1664512976:efa:mr:ofi_mr_cache_cleanup():466<info> MR cache stats: searches 2, deletes 2, hits 0 notify 142
libfabric:71:1664512976:efa:mr:ofi_mr_cache_cleanup():466<info> MR cache stats: searches 2, deletes 2, hits 0 notify 142
libfabric:19:1664512976:efa:mr:ofi_mr_cache_cleanup():466<info> MR cache stats: searches 49683, deletes 49683, hits 49679 notify 143
libfabric:22:1664512976:efa:mr:ofi_mr_cache_cleanup():466<info> MR cache stats: searches 2, deletes 2, hits 0 notify 143
libfabric:20:1664512976:efa:mr:ofi_mr_cache_cleanup():466<info> MR cache stats: searches 49683, deletes 49683, hits 49679 notify 145
libfabric:55:1664512976:efa:mr:ofi_mr_cache_cleanup():466<info> MR cache stats: searches 2, deletes 2, hits 0 notify 141
libfabric:53:1664512976:efa:mr:ofi_mr_cache_cleanup():466<info> MR cache stats: searches 2, deletes 2, hits 0 notify 142
libfabric:24:1664512976:efa:mr:ofi_mr_cache_cleanup():466<info> MR cache stats: searches 49683, deletes 49683, hits 49679 notify 144
libfabric:57:1664512976:efa:mr:ofi_mr_cache_cleanup():466<info> MR cache stats: searches 2, deletes 2, hits 0 notify 140
libfabric:61:1664512976:efa:mr:ofi_mr_cache_cleanup():466<info> MR cache stats: searches 2, deletes 2, hits 0 notify 140
```

Also notice the running pods and the CPU utilization in your monitoring terminals

![Gromacs Utilization](/images/aws-eks/gromacs-utilization.png)


####  3. Check output files in FSx volume

Once the job is completed the output files are in the FSx volume. To check that we will mount the volume in a new pod and open a shell in that pod.

Copy the pod manifest below into a file named `fsx-data.yaml`

```bash
cat > ~/environment/fsx-data.yaml << EOF
apiVersion: v1
kind: Pod
metadata:
  name: fsx-data
  namespace: gromacs
spec:
  containers:
  - name: app
    image: amazonlinux:2
    command: ["/bin/sh"]
    args: ["-c", "while true; do date; sleep 5; done"]
    volumeMounts:
    - name: data
      mountPath: /data
  volumes:
  - name: data
    persistentVolumeClaim:
      claimName: fsx-pvc
EOF
```

Create the pod.

```bash
kubectl apply -f ~/environment/fsx-data.yaml
```

Once the pod is in Running state, open a shell into it

```bash
kubectl -n gromacs exec -it $(kubectl -n gromacs get pods | grep fsx-data | head -n 1 | cut -d ' ' -f 1) -- bash
```

Describe the volumes mounted in the pod
```bash
df -h
```
Notice the FSx volume is mounted under `/data`.

Check that the output data from the Gromacs MPI job is in the `/data` directory.

```bash
ls -alh /data
```

You should see a list like the one below:

```text
...
total 9.4M
drwxr-xr-x 3 root root  33K Sep 30 04:29 .
drwxr-xr-x 1 root root   29 Sep 30 04:34 ..
-rw-r--r-- 1 root root 797K Sep 30 04:29 md_0_1.cpt
-rw-r--r-- 1 root root 8.2K Sep 30 04:29 md_0_1.edr
-rw-r--r-- 1 root root 2.3M Sep 30 04:29 md_0_1.gro
-rw-r--r-- 1 root root  36K Sep 30 04:29 md_0_1.log
-rw-r--r-- 1 root root 1.3M Sep 30 04:29 md_0_1.xtc
-rw-r--r-- 1 root root 797K Sep 30 04:29 md_0_1_prev.cpt
```

You can type `exit` to close the data pod shell.

Congratulations, you have successfully run a tightly coupled MPI job on two nodes using Gromacs to simulate a molecular process (TODO: ... Lowell). If the output data is copied to a desktop where VMD is installed, it can be visualized with the following command:

```bash
/usr/local/bin/vmd md_0_1.gro md_0_1.xtc
```

And visualized, the output would look like the image below:

![VMD Visualization](/images/aws-eks/results.png)
