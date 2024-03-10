Repo=https://argoproj.github.io/argo-helm
Chart=argo-cd
Target=argo-cd
NameSpace=argo-cd
Version=6.6.0

helm upgrade --install ${Target} ${Chart} \
  --repo ${Repo} \
  --namespace ${NameSpace} \
  --create-namespace \
  --version ${Version} \
  -f values.yaml
