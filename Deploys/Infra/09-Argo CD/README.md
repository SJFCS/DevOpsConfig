## getPasswd
```bash
kubectl -n argo-cd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```
## build
```bash
kustomize build --enable-helm .
```

faq: additionalValuesFiles 部分无法合并如 extraContainers 会变成替换 让我想到diect了list

merging maps is desirable and merging lists is not desirable

https://github.com/helm/helm/issues/3486



我认为引入新版本的--set和--values是有意义的，比如，对于高优先级的值，引入--overrideSet和--overrideValues。至于在图表中设置值，可以允许另一个名为overrideValues.yaml的文件，它设置的值的优先级高于values.yaml文件中的值。