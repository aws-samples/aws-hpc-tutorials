+++
title = "f. Run network bandwidth tests"
date = 2022-09-28T10:46:30-04:00
weight = 70
tags = ["tutorial", "hpc", "Kubernetes"]
+++

In this section, you will run the OSU ping pong benchmark to compare network bandwidth without and with [Elastic Fabric Adapter (EFA)](https://aws.amazon.com/hpc/efa/).


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

Keep watching the pods state till they enter `Running` state. `Ctrl-c` to exit

```bash
kubectl get pods -n gromacs -w
```

Read test results as soon as the launcher pod enters the Running state

```bash
kubectl -n gromacs logs -f $(kubectl -n gromacs get pods | grep sockets-launcher | head -n 1 | cut -d ' ' -f 1)
```

You should see results similar to the ones below

```text
...
# OSU MPI Bi-Directional Bandwidth Test v5.9
# Size      Bandwidth (MB/s)
1                       0.13
2                       0.24
4                       0.59
8                       1.53
16                      2.62
32                      8.87
64                     17.99
128                    35.85
256                    70.93
512                   139.83
1024                  278.79
2048                  542.85
4096                  952.30
8192                 1661.67
16384                1958.80
32768                2208.05
65536                1715.66
131072               1347.34
262144               1239.16
524288               1245.57
1048576              1290.13
2097152              1246.66
4194304              1265.38
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

Keep watching the pods state till they enter `Running` state. `Ctrl-c` to exit

```bash
kubectl get pods -n gromacs -w
```

Read test results as soon as the launcher pod enters the Running state

```bash
kubectl -n gromacs logs -f $(kubectl -n gromacs get pods | grep efa-launcher | head -n 1 | cut -d ' ' -f 1)
```

You should see results similar to the ones below

```text
...
# OSU MPI Bi-Directional Bandwidth Test v5.9
# Size      Bandwidth (MB/s)
1                       1.27
2                       2.57
4                       5.14
8                      10.24
16                     20.51
32                     40.90
64                     81.65
128                   162.69
256                   324.51
512                   639.93
1024                 1280.27
2048                 2505.02
4096                 4702.24
8192                 7808.41
16384                9197.45
32768                9504.72
65536                9452.36
131072               9214.24
262144               9917.26
524288              10328.33
1048576             10663.90
2097152             10640.11
4194304             10513.05
```

Notice that when EFA is turned on, the benchmark shows higher bandwidth.


Delete the test pods.
```bash
kubectl delete -f ~/environment/osu-bandwidth-efa.yaml
```