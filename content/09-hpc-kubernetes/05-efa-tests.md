+++
title = "e. Run EFA tests"
date = 2022-09-28T10:46:30-04:00
weight = 80
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
                nvidia.com/gpu: 0
                hugepages-2Mi: 5120Mi
                vpc.amazonaws.com/efa: 0
                memory: 8000Mi
              requests:
                nvidia.com/gpu: 0
                hugepages-2Mi: 5120Mi
                vpc.amazonaws.com/efa: 0
                memory: 8000Mi
```

Replace {IMAGE} with the Gromacs container image URI that you pushed to ECR in the previous lab.

```
export IMAGE=<paste image uri here>
sed -i 's/{IMAGE}/${IMAGE}/g' ./osu-latency-sockets.yaml
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

TODO: Post results here

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
sed -i 's/{IMAGE}/${IMAGE}/g' ./osu-latency-efa.yaml
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

TODO: Post results here

Notice that when EFA is turned on, the benchmark shows lower latency.
