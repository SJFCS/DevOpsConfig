Repo=https://charts.jetstack.io
Chart=cert-manager
Target=cert-manager
NameSpace=cert-manager
Version=1.14.4

helm upgrade --install ${Target} ${Chart} \
  --repo ${Repo} \
  --namespace ${NameSpace} \
  --create-namespace \
  --version ${Version} \
  -f values.yaml
