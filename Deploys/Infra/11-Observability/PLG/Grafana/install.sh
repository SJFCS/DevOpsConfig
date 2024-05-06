## 部署 Grafana
helm upgrade --install grafana  \
--namespace loki \
--create-namespace \
-f values-grafana.yaml \
--version 7.3.7 \
grafana/grafana

## 获取 Grafana 初始 admin 密码

kubectl get secret -n loki grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
