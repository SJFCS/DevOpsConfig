## 部署 Promtail
helm upgrade --install promtail  \
--namespace loki \
--create-namespace \
-f values-promtail.yaml \
--version 6.15.5 \
grafana/promtail