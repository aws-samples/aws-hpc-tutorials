+++
title = "f. Run network latency tests"
date = 2022-09-28T10:46:30-04:00
weight = 60
tags = ["tutorial", "hpc", "Kubernetes"]
+++

In this section, you will run OSU latency benchmarks to compare network speed with and without Elastic Fabric Adapter.  

1. Run test with sockets provider

Copy the MPIJob manifest below into a file named `osu-latency-sockets.yaml`, 

```yaml
apiVersion: kubeflow.org/v2beta1
kind: MPIJob
metadata:
  name: test-osu-latency-sockets
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
              sizeLimit: 128Mi
          containers:
          - image: "{IMAGE}"
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
          - image: "{IMAGE}"
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
```

Configure environment variable IMAGE with URI of container image built in the previous lab.

```
export IMAGE=<paste image uri here>
```

Replace {IMAGE} with the Gromacs container image URI.

```
sed -i "s#{IMAGE}#${IMAGE}#g" ./osu-latency-sockets.yaml
```

Run the latency test MPIJob without EFA

```
kubectl apply -f ./osu-latency-sockets.yaml
```

Read test results as soon as the launcher pod enters the Running state

```
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

2. Run test with efa provider

Copy the MPIJob manifest below into a file named `osu-latency-efa.yaml`, 

```yaml
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
          - image: "{IMAGE}"
            name: init
            command: ["sh", "-c", "sleep 5"]
          volumes:
          - name: cache-volume
            emptyDir:
              medium: Memory
              sizeLimit: 128Mi
          containers:
          - image: "{IMAGE}"
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
          - image: "{IMAGE}"
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
```

Replace {IMAGE} with the Gromacs container image URI that you pushed to ECR in the previous lab.

```
sed -i "s#{IMAGE}#${IMAGE}#g" ./osu-latency-efa.yaml
```

Run the latency test MPIJob with EFA

```
kubectl apply -f ./osu-latency-efa.yaml
```

Read test results as soon as the launcher pod enters the Running state

```
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
