## getPasswd
```bash
kubectl -n argo-cd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```
## build
```bash
kustomize build --enable-helm .
```