https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack

kubectl exec -it grafana-9df57cdc4-xnmth /bin/sh
grafana-cli admin reset-admin-password password

❯ kubectl -n prometheus get secrets prometheus-grafana -ojson |jq -r '.data | map_values(@base64d)'

helm  -n prometheus upgrade --install prometheus prometheus-community/kube-prometheus-stack -f values.yaml


