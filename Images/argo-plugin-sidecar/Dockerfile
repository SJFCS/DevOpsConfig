FROM ubuntu:24.04

LABEL org.opencontainers.image.source=https://github.com/SJFCS/DevOpsConfig

RUN apt-get update;\
    apt-get install -y ca-certificates wget tar;\
    apt-get autoclean;\
    rm -rf /var/lib/apt/lists/*
RUN wget "https://get.helm.sh/helm-v3.14.2-linux-amd64.tar.gz" -O - | tar xz && mv ./linux-amd64/helm /usr/local/bin/helm && chmod +x /usr/local/bin/helm
RUN wget  "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv5.3.0/kustomize_v5.3.0_linux_amd64.tar.gz" -O -|tar xz \
    && mv ./kustomize /usr/local/bin/kustomize \
    && chmod +x /usr/local/bin/kustomize