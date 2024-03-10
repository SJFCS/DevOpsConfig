kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl apply -f - -n kube-system

helm install -n metallb-system  metallb metallb/metallb --create-namespace

kubelet apply -f first-pool.yaml



# Repo=https://docs.tigera.io/calico/charts
# Chart=tigera-operator
# Target=tigera-operator
# NameSpace=tigera-operator
# Version=v3.27.2

# helm upgrade --install ${Target} ${Chart} \
#   --repo ${Repo} \
#   --namespace ${NameSpace} \
#   --create-namespace \
#   --version ${Version} \
#   -f values.yaml 
