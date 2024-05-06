然后您可以在应用程序清单中内联定义Helm值：

  source:
    path: your-app
    plugin:
      name: argocd-vault-plugin-helm
      env:
        - name: HELM_VALUES
          value: |
            # non-vault helm values are specified normally
            someValue: lasldkfjlksa
            moreStuff:
              - a
              - b
              - c

            # get mysql credentials from kv2 vault secret at path "kv/mysql"
            mysql:
              username: <path:kv/data/mysql#user>
              password: <path:kv/data/mysql#password>
              hostname: <path:kv/data/mysql#hostname>



apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: simple-helm
  namespace: argocd
spec:
  destination:
    name: ''
    namespace: default
    server: https://kubernetes.default.svc
  project: default
  source:
    path: simple-with-envs # (1)
    repoURL: https://github.com/piomin/sample-generic-helm-charts.git 
    targetRevision: HEAD
    plugin: # (2)
      env:
        - name: HELM_VALUES # (3)
          value: |
            image:
              registry: quay.io
              repository: pminkows/sample-kotlin-spring
              tag: "1.4.30"

            app:
              name: sample-spring-boot-kotlin
              replicas: 1
              ports:
                - name: http
                  value: 8080
              envs:
                - name: PASS
                  value: <path:kv-v2/data/argocd#password> # (4)