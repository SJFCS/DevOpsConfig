helm repo add minio-operator https://operator.min.io
helm search repo minio-operator

helm install \
  --namespace minio-operator \
  --create-namespace \
  operator minio-operator/operator


kubectl get secret/console-sa-secret -n minio-operator -o json | jq -r ".data.token" | base64 -d
