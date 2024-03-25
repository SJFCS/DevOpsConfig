FROM busybox:stable-uclibc

LABEL org.opencontainers.image.source=https://github.com/SJFCS/DevOpsConfig


RUN wget "https://get.helm.sh/helm-v3.14.2-linux-amd64.tar.gz" -O - | tar xz && mv ./linux-amd64/helm /tools/helm && chmod +x /tools/helm &&
RUN wget "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv5.3.0/kustomize_v5.3.0_linux_amd64.tar.gz" -O -|tar xz && mv ./kustomize /tools/kustomize && chmod +x /tools/kustomize
