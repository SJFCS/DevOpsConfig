## 部署 Loki
helm upgrade --install loki  \
--namespace loki \
--create-namespace \
-f values-loki.yaml \
--version 5.47.1 \
grafana/loki