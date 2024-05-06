## ES
helm repo add elastic https://helm.elastic.co
helm repo update
helm install elastic-operator elastic/eck-operator -n elastic-system --create-namespace

user: elastic
passwd:
PASSWORD=`kubectl -n elk-logging get secret logging-es-elastic-user -o jsonpath='{.data.elastic}' | base64 --decode; echo`
PASSWORD=`kubectl -n elk-logging get secret logging-es-elastic-user -o go-template='{{.data.elastic | base64decode}}';echo`
kubectl port-forward service/quickstart-es-http 9200
curl -u "elastic:$PASSWORD" -k "https://localhost:9200"

## istio
kubectl create namespace dapr-monitoring
helm install elasticsearch elastic/elasticsearch -n dapr-monitoring --set replicas=1
helm install kibana elastic/kibana -n dapr-monitoring

https://v1-10.docs.dapr.io/docs/fluentd-config-map.yaml
https://v1-10.docs.dapr.io/docs/fluentd-dapr-with-rbac.yaml

https://v1-10.docs.dapr.io/zh-hans/operations/monitoring/logging/fluentd/

# kubectl create -f https://download.elastic.co/downloads/eck/2.12.1/crds.yaml

# kubectl apply -f https://download.elastic.co/downloads/eck/2.12.1/operator.yaml



请注意，处理程序配置中的 address: "fluentd-es.logging:24224" 指向我们在示例堆栈中设置的 Fluentd 守护程序。

$ kubectl -n logging port-forward $(kubectl -n logging get pod -l app=kibana -o jsonpath='{.items[0].metadata.name}') 5601:5601 &


## ydzs

# 运行容器生成证书，containerd下面用nerdctl
# 将 pcks12 中的信息分离出来，写入文件
$ cd elastic-certs && openssl pkcs12 -nodes -passin pass:'' -in elastic-certificates.p12 -out elastic-certificate.pem





https://access.redhat.com/documentation/zh-cn/openshift_container_platform/3.11/html/configuring_clusters/configuring-curator
https://access.redhat.com/documentation/zh-cn/openshift_container_platform/4.3/html/logging/cluster-logging-external

