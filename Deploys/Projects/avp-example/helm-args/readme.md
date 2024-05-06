传递隐藏参数
  source:
    path: your-app
    plugin:
      name: argocd-vault-plugin-helm
      env:
        - name: HELM_ARGS
          value: -f values-dev.yaml -f values-dev-tag.yaml