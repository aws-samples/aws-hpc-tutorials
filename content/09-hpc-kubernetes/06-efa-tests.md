+++
title = "f. Run network latency tests"
date = 2022-09-28T10:46:30-04:00
weight = 60
tags = ["tutorial", "hpc", "Kubernetes"]
+++

In this section, you will run the OSU ping pong benchmark to compare network latency without and with [Elastic Fabric Adapter (EFA)](https://aws.amazon.com/hpc/efa/).


####  1. Retrieve the container image URI

Configure environment variable `IMAGE_URI` with URI of container image built in the previous lab.

```bash
IMAGE_URI=`aws ecr describe-repositories --query repositories[].[repositoryUri] --region ${AWS_REGION} | grep "/${REPO_NAME}" | tr -d '"' | xargs`
```

####  2. Run test with sockets provider

Copy the MPIJob manifest below into a file named `osu-latency-sockets.yaml`:

```bash
cat > ~/environment/osu-latency-sockets.yaml << EOF
apiVersion: kubeflow.org/v2beta1
kind: MPIJob
metadata:
  name: test-osu-latency-sockets
  namespace: gromacs
spec:
  slotsPerWorker: 72
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
            name: test-osu-latency-sockets-launcher
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
            - /opt/view/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency
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
            name: test-osu-latency-sockets-worker
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

Run the latency test MPIJob without EFA

```bash
kubectl apply -f ~/environment/osu-latency-sockets.yaml
```

Keep wathing the pods state till they enter `Running` state. `Ctrl-c` to exit

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
# OSU MPI Latency Test v5.9
# Size          Latency (us)
0                      43.41
1                      43.03
2                      43.01
4                      42.88
8                      43.17
16                     43.29
32                     43.65
64                     43.87
128                    44.07
256                    43.76
512                    43.61
1024                   45.21
2048                   45.86
4096                   49.59
8192                   54.98
16384                  63.85
32768                  80.77
65536                 209.21
131072                236.28
262144                283.64
524288                364.55
1048576               529.79
2097152               975.90
4194304              2520.77
```

Delete the pods using the sockets.
```bash
kubectl delete -f ~/environment/osu-latency-sockets.yaml
```

####  3. Run test with efa provider

Copy the MPIJob manifest below into a file named `osu-latency-efa.yaml`, 

```bash
cat > << EOF
apiVersion: kubeflow.org/v2beta1
kind: MPIJob
metadata:
  name: test-osu-latency-efa
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
            name: test-osu-latency-efa-launcher
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
            - /opt/view/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency
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
            name: test-osu-latency-efa-worker
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
kubectl apply -f ~/environment/osu-latency-efa.yaml
```

Keep wathing the pods state till they enter `Running` state. `Ctrl-c` to exit

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
# OSU MPI Latency Test v5.9
# Size          Latency (us)
0                      20.34
1                      20.35
2                      20.35
4                      20.37
8                      20.75
16                     20.76
32                     20.78
64                     20.82
128                    20.86
256                    20.93
512                    21.11
1024                   21.59
2048                   22.70
4096                   25.09
8192                   31.32
16384                  33.67
32768                  38.60
65536                  46.27
131072                109.30
262144                133.17
524288                236.31
1048576               440.64
2097152               846.39
4194304              1608.11
```

Notice that when EFA is turned on, the benchmark shows lower latency.


Delete the pods using the sockets.
```bash
kubectl delete -f ~/environment/osu-latency-efa.yaml
```