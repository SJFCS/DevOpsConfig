

## build & push
- https://docs.github.com/zh/packages/managing-github-packages-using-github-actions-workflows/publishing-and-installing-a-package-with-github-actions
- https://prinsss.github.io/ghcr-io-with-github-actions/

## sync 
- https://github.com/WeiyiGeek/action-sync-images
- https://imroc.cc/kubernetes/trick/images/sync-images-with-skopeo
- https://cloud.tencent.com/developer/article/2065531
```yaml
account:
  - Registry: registry.cn-hangzhou.aliyuncs.com
    username: ${{ aliyuncs_username }}
    password: ${{ aliyuncs_password }}
  - Registry: ghcr.io
    username: ${{ github.actor }}
    password: ${{ secrets.GITHUB_TOKEN }}
sync-rule:
- source: k8s.gcr.io/image:tag
  destination: 
  - registry1.com/image:tag
  - registry2.com/image:tag
```