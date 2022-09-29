+++
title = "f. Run Gromacs MPI job"
date = 2022-09-28T10:46:30-04:00
weight = 80
tags = ["tutorial", "hpc", "Kubernetes"]
+++

In this section, you will run a Gromacs MPI job distributed between two nodes in your Kubernetes cluster.

1. Create MPIJob manifest

Copy the MPIJob manifest below into a file named `gromacs-mpi.yaml`, 

```yaml
apiVersion: kubeflow.org/v2beta1
kind: MPIJob
metadata:
  name: gromacs-mpi
  namespace: gromacs
spec:
  slotsPerWorker: 1
  runPolicy:
    cleanPodPolicy: Running
  mpiReplicaSpecs:
    Launcher:
      replicas: 1
      template:
         spec:
          restartPolicy: OnFailure
          initContainers:
          - image: "{IMAGE}"
            name: init
            command: ["sh", "-c", "sleep 5"]
          volumes:
          - name: cache-volume
            emptyDir:
              medium: Memory
              sizeLimit: 1024Mi
          - name: data
            persistentVolumeClaim:
              claimName: fsx-pvc
          containers:
          - image: "{IMAGE}"
            imagePullPolicy: Always
            name: gromacs-mpi-launcher
            volumeMounts:
            - name: cache-volume
              mountPath: /dev/shm
            - name: data
              mountPath: /data
            env:
            - name: OMP_NUM_THREADS
              value: "1"
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
            - "$OMP_NUM_THREADS"
            - -deffnm
            - "${DATA_DIR}/md_0_1"
            - -s
            - "${DATA_DIR}/md_0_1.tpr"
    Worker:
      replicas: 2
      template:
        spec:
          volumes:
          - name: cache-volume
            emptyDir:
              medium: Memory
              sizeLimit: 1024Mi
          - name: data
            persistentVolumeClaim:
              claimName: fsx-pvc
          containers:
          - image: "{IMAGE}"
            imagePullPolicy: Always
            name: gromacs-mpi-worker
            volumeMounts:
            - name: cache-volume
              mountPath: /dev/shm
            - name: data
              mountPath: /data
            resources:
              limits:
                nvidia.com/gpu: 0
                hugepages-2Mi: 5120Mi
                vpc.amazonaws.com/efa: 1
                memory: 8000Mi
              requests:
                nvidia.com/gpu: 0
                hugepages-2Mi: 5120Mi
                vpc.amazonaws.com/efa: 1
                memory: 8000Mi
```

Replace {IMAGE} with the Gromacs container image URI that you pushed to ECR in the previous lab.

```
export IMAGE=<paste image uri here>
sed -i 's/{IMAGE}/${IMAGE}/g' ./gromacs-mpi.yaml
```

2. Run the Gromacs MPIJob

```
kubectl apply -f ./gromacs-mpi.yaml
```

Follow the launcher logs as soon as the pod enters the Running state

```
kubectl -n gromacs logs -f $(kubectl -n gromacs get pods | grep gromacs-mpi-launcher | head -n 1 | cut -d ' ' -f 1)
```

You should see logs similar to the ones below

TODO: Post results here


3. Check output files in FSx volume

Once the job is completed the output files are in the FSx volume. To check that we will mount the volume in a new pod and open a shell in that pod.

Copy the pod manifest below into a file named `fsx-data.yaml`

```yaml
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
```

Create the pod.

```bash
kubectl apply -f ./fsx-data.yaml
```

Once the pod is in Running state, open a shell into it

```bash
kubectl -n gromacs exec -it $(kubectl -n gromacs | grep fsx-data | head -n 1 | cut -d ' ' -f 1) -- bash
```

Describe the volumes mounted in the pod
```
df -h
```
Notice the FSx volume is mounted under `/data`.

Check that the output data from the Gromacs MPI job is in the `/data` directory.

```
ls -alh /data
```

You should see a list like the one below:

TODO: Show list here