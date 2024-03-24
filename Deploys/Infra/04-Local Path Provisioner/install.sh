Repo=https://charts.containeroo.ch
Chart=local-path-provisioner
Target=local-path-storage
NameSpace=local-path-storage
Version=0.0.26

helm upgrade --install ${Target} ${Chart} \
  --repo ${Repo} \
  --namespace ${NameSpace} \
  --create-namespace \
  --version ${Version} \
  -f values.yaml
