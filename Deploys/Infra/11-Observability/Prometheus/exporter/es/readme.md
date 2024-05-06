helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm -n elk-logging upgrade --install elasticsearch-exporter prometheus-community/prometheus-elasticsearch-exporter -f values.yaml



1. Get the application URL by running these commands:
  export POD_NAME=$(kubectl get pods --namespace elk-logging -l "app=elasticsearch-exporter-prometheus-elasticsearch-exporter" -o jsonpath="{.items[0].metadata.name}")
  echo "Visit http://127.0.0.1:9108/metrics to use your application"
  kubectl port-forward $POD_NAME 9108:9108 --namespace elk-logging