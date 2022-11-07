+++
title = "g. Run network bandwidth tests"
date = 2022-09-28T10:46:30-04:00
weight = 70
tags = ["tutorial", "hpc", "Kubernetes"]
+++

In this section, you will run the OSU bi-directional bandwidth test to compare network bandwidth without and with [Elastic Fabric Adapter (EFA)](https://aws.amazon.com/hpc/efa/).


####  1. Retrieve the container image URI

Configure environment variable `IMAGE_URI` with URI of container image built in the previous lab.

```bash
export IMAGE_URI=$(aws ecr --region ${AWS_REGION} describe-repositories --repository-name sc22-container --query "repositories[0].repositoryUri" --output text)                                                                                                                                                
echo $IMAGE_URI
```

####  2. Run test with sockets provider

Copy the MPIJob manifest below into a file named `osu-bandwidth-sockets.yaml`:

```bash
cat > ~/environment/osu-bandwidth-sockets.yaml << EOF
apiVersion: kubeflow.org/v2beta1
kind: MPIJob
metadata:
  name: test-osu-bandwidth-sockets
  namespace: gromacs
spec:
  slotsPerWorker: 96
  runPolicy:
    cleanPodPolicy: Running
  mpiReplicaSpecs:
    Launcher:
      replicas: 1
      template:
         spec:
          restartPolicy: OnFailure
          initContainers:
          - image: "${IMAGE_URI}"
            name: init
            command: ["sh", "-c", "sleep 5"]
          volumes:
          - name: cache-volume
            emptyDir:
              medium: Memory
              sizeLimit: 128Mi
          containers:
          - image: "${IMAGE_URI}"
            imagePullPolicy: Always
            name: test-osu-bandwidth-sockets-launcher
            volumeMounts:
            - name: cache-volume
              mountPath: /dev/shm
            command:
            - /opt/view/bin/mpirun
            - --allow-run-as-root
            - -x
            - FI_LOG_LEVEL=info
            - -x
            - FI_PROVIDER=sockets
            - -np
            - "2"
            - -npernode
            - "1"
            - /opt/view/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_bibw
    Worker:
      replicas: 2
      template:
        spec:
          volumes:
          - name: cache-volume
            emptyDir:
              medium: Memory
              sizeLimit: 128Mi
          containers:
          - image: "${IMAGE_URI}"
            imagePullPolicy: Always
            name: test-osu-bandwidth-sockets-worker
            volumeMounts:
            - name: cache-volume
              mountPath: /dev/shm
            resources:
              limits:
                hugepages-2Mi: 5120Mi
                vpc.amazonaws.com/efa: 0
                memory: 8000Mi
              requests:
                hugepages-2Mi: 5120Mi
                vpc.amazonaws.com/efa: 0
                memory: 8000Mi
EOF
```

Run the bandwidth test MPIJob without EFA

```bash
kubectl apply -f ~/environment/osu-bandwidth-sockets.yaml
```

Watch the pods in the gromacs namespace until the launcher pod enters `Running` or `Completed` state. Press `Ctrl-c` to exit.

```bash
kubectl get pods -n gromacs -w
```

Read test results when the launcher pod is in the Running or Completed state.

```bash
kubectl -n gromacs logs -f $(kubectl -n gromacs get pods | grep sockets-launcher | head -n 1 | cut -d ' ' -f 1)
```

You should see results similar to the ones below:

```text
...
# OSU MPI Bi-Directional Bandwidth Test v5.9
# Size      Bandwidth (MB/s)
1                       0.08
2                       0.20
4                       1.01
8                       2.02
16                      3.89
32                      7.64
64                     15.91
128                    31.15
256                    60.60
512                   113.85
1024                  233.45
2048                  431.19
4096                  769.80
8192                 1306.48
16384                1810.85
32768                1993.74
65536                1444.50
131072               1301.89
262144               1241.27
524288               1215.96
1048576              1200.83
2097152              1195.40
4194304              1193.14
```

Delete the test pods.

```bash
kubectl delete -f ~/environment/osu-bandwidth-sockets.yaml
```

####  3. Run test with efa provider

Create a new MPI job manifest with Elastic Fabric Adapter support.  This will enable high-bandwidth networking for MPI.

```bash
cat > ~/environment/osu-bandwidth-efa.yaml << EOF
apiVersion: kubeflow.org/v2beta1
kind: MPIJob
metadata:
  name: test-osu-bandwidth-efa
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
          initContainers:
          - image: "${IMAGE_URI}"
            name: init
            command: ["sh", "-c", "sleep 5"]
          volumes:
          - name: cache-volume
            emptyDir:
              medium: Memory
              sizeLimit: 128Mi
          containers:
          - image: "${IMAGE_URI}"
            imagePullPolicy: Always
            name: test-osu-bandwidth-efa-launcher
            volumeMounts:
            - name: cache-volume
              mountPath: /dev/shm
            command:
            - /opt/view/bin/mpirun
            - --allow-run-as-root
            - -x
            - FI_LOG_LEVEL=info
            - -x
            - FI_PROVIDER=efa
            - -np
            - "2"
            - -npernode
            - "1"
            - /opt/view/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_bibw
    Worker:
      replicas: 2
      template:
        spec:
          volumes:
          - name: cache-volume
            emptyDir:
              medium: Memory
              sizeLimit: 128Mi
          containers:
          - image: "${IMAGE_URI}"
            imagePullPolicy: Always
            name: test-osu-bandwidth-efa-worker
            volumeMounts:
            - name: cache-volume
              mountPath: /dev/shm
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

Run the latency test MPIJob with EFA

```bash
kubectl apply -f ~/environment/osu-bandwidth-efa.yaml
```

Watch the pods in the gromacs namespace until the launcher pod enters `Running` or `Completed` state. Press `Ctrl-c` to exit.

```bash
kubectl get pods -n gromacs -w
```

Read test results when the launcher pod is in Running or Completed state.

```bash
kubectl -n gromacs logs -f $(kubectl -n gromacs get pods | grep efa-launcher | head -n 1 | cut -d ' ' -f 1)
```

You should see results similar to the ones below:

```text
...
# OSU MPI Bi-Directional Bandwidth Test v5.9
# Size      Bandwidth (MB/s)
1                       1.61
2                       3.26
4                       6.37
8                      12.92
16                     25.92
32                     52.47
64                    104.00
128                   205.88
256                   410.65
512                   796.56
1024                 1528.26
2048                 2761.29
4096                 4749.16
8192                 7923.42
16384                9315.34
32768               10712.90
65536               11588.50
131072              10424.35
262144              12896.79
524288              14449.65
1048576             15103.77
2097152             14846.02
4194304             15450.91
```

Notice that when EFA is turned on, the benchmark shows higher bandwidth.


Delete the test pods.

```bash
kubectl delete -f ~/environment/osu-bandwidth-efa.yaml
```