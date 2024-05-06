#### 1.1、查看接口信息

```shell
curl --cert /etc/kubernetes/pki/etcd/healthcheck-client.crt --key /etc/kubernetes/pki/etcd/healthcheck-client.key  https://192.168.8.100:2379/metrics -k 
```

#### 1.2、创建service和Endpoints

#### 1.4、创建secret

```shell
# 2、接下来我们需要创建一个secret，让prometheus pod节点挂载
sudo kubectl create secret generic etcd-ssl \
--from-file=/etc/kubernetes/pki/etcd/healthcheck-client.crt \
--from-file=/etc/kubernetes/pki/etcd/healthcheck-client.key \
--from-file=/etc/kubernetes/pki/etcd/ca.crt -n prometheus

#### 1.5、编辑prometheus，把证书挂载进去


# 1、通过edit直接编辑prometheus
kubectl exec -it -n prometheus prometheus-prometheus-kube-prometheus-prometheus-0 --  ls /etc/prometheus/secrets/etcd-ssl/

```

#### 1.6、创建ServiceMonitor


之后可以在Prometheus的web界面上查看监控的节点信息：Status --> targets --> monitoring/etcd-k8s

#### 1.8、grafana模板导入

# 打开官网来的如下图所示，点击下载JSO文件
grafana官网：https://grafana.com/grafana/dashboards/3070
中文版ETCD集群插件：https://grafana.com/grafana/dashboards/9733