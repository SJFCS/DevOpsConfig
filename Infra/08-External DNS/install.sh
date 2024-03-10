kubectl create ns external-dns
kubectl apply -f cloudflare-api-token-for-external-dns-sealed-secret.yaml

Repo=https://kubernetes-sigs.github.io/external-dns/
Chart=external-dns
Target=external-dns
NameSpace=external-dns
Version=1.14.3

helm upgrade --install ${Target} ${Chart} \
  --repo ${Repo} \
  --namespace ${NameSpace} \
  --create-namespace \
  --version ${Version} \
  -f values.yaml
