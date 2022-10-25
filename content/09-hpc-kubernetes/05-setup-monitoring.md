+++
title = "d. Setup monitoring"
date = 2022-09-28T10:46:30-04:00
weight = 50
tags = ["tutorial", "hpc", "Kubernetes"]
+++

In this section, you will lean how to monitor your cluster as well as monitor the pods running on it.

There are several ways to set up monitoring. Here we will provide two approaches to illustrate the range from simple built-in command line-based monitoring to comprehensive graphical dashboard-based moniroting.

#### 1. Monitor using kubectl

This method allows viewing of cluster-wide metrics in textual form.

#### 1.1. Deploy metrics server

To enable utilization monitoring of the cluster using `kubectl`, deploy the Kubernetes metrics server by executing the following command:

```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

#### 1.2. Execute kubectl

To see node utilization of your cluster, execute

```bash
kubectl top node --use-protocol-buffers
```

Sample output:

```text
NAME                                           CPU(cores)   CPU%   MEMORY(bytes)   MEMORY%   
ip-192-168-68-194.us-east-2.compute.internal   201m         0%     1362Mi          0%        
ip-192-168-91-99.us-east-2.compute.internal    226m         0%     1001Mi          0%  
```

To see how much resources each pod is utilizing, execute
```bash
kubectl top pod -A --use-protocol-buffers
```

Sample output:

```text
NAMESPACE      NAME                                            CPU(cores)   MEMORY(bytes)   
default        bash                                            0m           81Mi            
grafana        grafana-7c4b6ccb8-q2qsv                         2m           71Mi            
gromacs        htop-bb6d4                                      1m           10Mi            
gromacs        htop-pdhmp                                      1m           6Mi             
kube-system    aws-efa-k8s-device-plugin-daemonset-q6cll       1m           6Mi             
kube-system    aws-efa-k8s-device-plugin-daemonset-srqdk       1m           6Mi             
kube-system    aws-node-crzgq                                  6m           83Mi            
kube-system    aws-node-qjx2h                                  4m           81Mi            
kube-system    coredns-f47955f89-dsrjp                         3m           27Mi            
kube-system    coredns-f47955f89-vvvn4                         3m           26Mi            
kube-system    fsx-csi-controller-78b5599496-2992k             9m           80Mi            
kube-system    fsx-csi-controller-78b5599496-5gf5k             5m           66Mi            
kube-system    fsx-csi-node-bxjzc                              2m           53Mi            
kube-system    fsx-csi-node-qs9dh                              8m           52Mi            
kube-system    kube-proxy-l6747                                11m          52Mi            
kube-system    kube-proxy-ntjf7                                13m          51Mi            
kube-system    metrics-server-64cf6869bd-b9lsg                 5m           28Mi            
mpi-operator   mpi-operator-65d47d6d67-dx7kk                   4m           24Mi            
prometheus     prometheus-alertmanager-6f64cb4659-wkbj5        1m           27Mi            
prometheus     prometheus-kube-state-metrics-77ddf69b4-z8z4z   1m           20Mi            
prometheus     prometheus-node-exporter-lm4rt                  0m           34Mi            
prometheus     prometheus-node-exporter-r4hbp                  0m           36Mi            
prometheus     prometheus-pushgateway-5f7dcb67bb-b4z5k         1m           21Mi            
prometheus     prometheus-server-584d5c7c84-gmf4z              7m           342Mi   
```

#### 2. Monitor using Prometheus and Grafana

This approach allow cluster-wide monitoring using a graphical web interface.

#### 2.1. Add helm repositories

Add the Prometheus and Grafana helm repositories

```bash
# add prometheus Helm repo
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

# add grafana Helm repo
helm repo add grafana https://grafana.github.io/helm-charts
```

#### 2.2. Deploy Prometheus

The Prometheus server collects and exports cluster metrics.

```bash
kubectl create namespace prometheus

helm install prometheus prometheus-community/prometheus \
    --namespace prometheus \
    --set alertmanager.persistentVolume.storageClass="gp2" \
    --set server.persistentVolume.storageClass="gp2"
```

To verify the deployment, execute:

```bash
kubectl get all -n prometheus
```

The expected output looks similar to this:

```text
NAME                                                READY   STATUS    RESTARTS   AGE
pod/prometheus-alertmanager-6f64cb4659-wkbj5        2/2     Running   0          107m
pod/prometheus-kube-state-metrics-77ddf69b4-z8z4z   1/1     Running   0          107m
pod/prometheus-node-exporter-lm4rt                  1/1     Running   0          107m
pod/prometheus-node-exporter-r4hbp                  1/1     Running   0          107m
pod/prometheus-pushgateway-5f7dcb67bb-b4z5k         1/1     Running   0          107m
pod/prometheus-server-584d5c7c84-gmf4z              2/2     Running   0          107m

NAME                                    TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
service/prometheus-alertmanager         ClusterIP   10.100.15.106   <none>        80/TCP     107m
service/prometheus-kube-state-metrics   ClusterIP   10.100.38.71    <none>        8080/TCP   107m
service/prometheus-node-exporter        ClusterIP   10.100.28.205   <none>        9100/TCP   107m
service/prometheus-pushgateway          ClusterIP   10.100.76.25    <none>        9091/TCP   107m
service/prometheus-server               ClusterIP   10.100.103.56   <none>        80/TCP     107m

NAME                                      DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
daemonset.apps/prometheus-node-exporter   2         2         2       2            2           <none>          107m

NAME                                            READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/prometheus-alertmanager         1/1     1            1           107m
deployment.apps/prometheus-kube-state-metrics   1/1     1            1           107m
deployment.apps/prometheus-pushgateway          1/1     1            1           107m
deployment.apps/prometheus-server               1/1     1            1           107m

NAME                                                      DESIRED   CURRENT   READY   AGE
replicaset.apps/prometheus-alertmanager-6f64cb4659        1         1         1       107m
replicaset.apps/prometheus-kube-state-metrics-77ddf69b4   1         1         1       107m
replicaset.apps/prometheus-pushgateway-5f7dcb67bb         1         1         1       107m
replicaset.apps/prometheus-server-584d5c7c84              1         1         1       107m
```


#### 2.4. Deploy Grafana

The Grafana server displays metrics from Prometheus as graphical dashboards.

First create a data source manifest for Prometheus:

```bash
mkdir ${HOME}/environment/grafana

cat << EoF > ${HOME}/environment/grafana/prometheus.yaml
datasources:
  datasources.yaml:
    apiVersion: 1
    datasources:
    - name: Prometheus
      type: prometheus
      url: http://prometheus-server.prometheus.svc.cluster.local
      access: proxy
      isDefault: true
EoF
```

We will use a classic Load Balancer to expose the Grafana dashboard outside of the Kubernetes cluster. Use the following snippet to ensure that only one of the security groups linked to the cluster nodes has the `kubernetes.io/cluster/eks-hpc=owned` tag.

```bash
export SGID=$(aws ec2 describe-security-groups | jq -r ".SecurityGroups[] | .GroupName, .GroupId" | grep EFA -A1 | grep -v EFA)
aws ec2 delete-tags --resources $SGID --tags Key=kubernetes.io/cluster/eks-hpc
```

Then deploy Grafana and configure it with Prometheus as the data source:

```bash
kubectl create namespace grafana

helm install grafana grafana/grafana \
    --namespace grafana \
    --set persistence.storageClassName="gp2" \
    --set persistence.enabled=true \
    --set adminPassword='SC22!sAWSome' \
    --values ${HOME}/environment/grafana/prometheus.yaml \
    --set service.type=LoadBalancer
```

To verify the deployment, execute:

```bash
kubectl get all -n grafana
```

The expected output looks similar to the following:

```text
NAME                          READY   STATUS    RESTARTS   AGE
pod/grafana-7c4b6ccb8-q2qsv   1/1     Running   0          110m

NAME              TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
service/grafana   LoadBalancer   10.100.159.35   <pending>     80:31114/TCP   110m

NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/grafana   1/1     1            1           110m

NAME                                DESIRED   CURRENT   READY   AGE
replicaset.apps/grafana-7c4b6ccb8   1         1         1       110m
```

#### 2.5. Connect and login to Grafana

In a production deployment, Grafana would likely be exposed via an Application Load Balancer and served with a domain name and an SSL certificate. For the purposes of the lab we are using a classic lod balancer and traffic is over HTTP.

To get the address whee the grafana service is available, execute:

```
export LB=$(kubectl -n grafana get svc grafana -o json | jq -r .status.loadBalancer.ingress[].hostname)

echo "Your Grafana URL is here:"
echo "https://${LB}
```

 You will see the Grafana login screen.

![Grafana Login](/images/aws-eks/grafana-login.png)

Login as user `admin`
To obtain the password, execute the following command:

```bash
kubectl get secret --namespace grafana grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

#### 2.6. Open dashboards

We will import two standard dashboards from Grafana.com

#### 2.6.1. Cluster Monitoring Dashboard

* Click on Dashboards->Import
* Enter 7249 dashboard id under Grafana.com Dashboard
* Click ‘Load’
* Select ‘Prometheus’ as the endpoint under prometheus data sources drop down
* Click ‘Import’

You should see a Cluster monitoring dashboard similar to the one below

![Cluster Monitoring](/images/aws-eks/grafana-dashboard-cluster.png)

#### 2.6.2. Pod Monitoring Dashboard

* Click on Dashboards->Import
* Enter 747 dashboard id under Grafana.com Dashboard
* Click 'Load'
* Select 'Prometheus' as the endpoint under prometheus data sources drop down
* Click 'Import'

You should see a Pod monitoring dashboard similar to the one below

![Pod Monitoring](/images/aws-eks/grafana-dashboard-pod.png)
