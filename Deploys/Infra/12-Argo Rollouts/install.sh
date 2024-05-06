helm repo add argo https://argoproj.github.io/argo-helm
helm install -n argo-rollouts --create-namespace argo-rollouts argo/argo-rollouts --version 2.35.1 --values values.yaml