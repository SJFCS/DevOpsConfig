kubectl get crd gateways.gateway.networking.k8s.io &> /dev/null || \
{ kubectl kustomize "github.com/kubernetes-sigs/gateway-api/config/crd?ref=444631bfe06f3bcca5d0eadf1857eac1d369421d" | kubectl apply -f -; }


kubectl label namespace default istio-injection=enabled

kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.21/samples/bookinfo/platform/kube/bookinfo.yaml

kubectl exec "$(kubectl get pod -l app=ratings -o jsonpath='{.items[0].metadata.name}')" -c ratings -- curl -sS productpage:9080/productpage | grep -o "<title>.*</title>"


kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.21/samples/bookinfo/networking/bookinfo-gateway.yaml


kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.21/samples/bookinfo/gateway-api/bookinfo-gateway.yaml 

curl -s "http://192.168.8.154/productpage" |grep  "reviews"


kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.21/samples/bookinfo/platform/kube/bookinfo-versions.yaml
https://istio.io/latest/docs/examples/bookinfo/



clean: https://raw.githubusercontent.com/istio/istio/release-1.21/samples/bookinfo/platform/kube/cleanup.sh
