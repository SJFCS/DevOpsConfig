FROM ubuntu:24.04

LABEL org.opencontainers.image.source=https://github.com/SJFCS/DevOpsConfig

RUN apt-get update && apt-get install ca-certificates wget tar -y ; apt-get autoclean; rm -rf /var/lib/apt/lists/*
RUN wget "https://get.helm.sh/helm-v3.14.2-linux-amd64.tar.gz" -O - | tar xz && mv ./linux-amd64/helm /usr/local/bin/helm && chmod +x /us/helm 
RUN wget  "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv5.3.0/kustomize_v5.3.0_linux_amd64.tar.gz" -O -|tar xz && mv ./kustomize /usr/local/bin/kustomize && chmod +x /tools/kustomize







# RUN curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
# RUN apt-get install apt-transport-https --yes
# echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
# RUN apt-get update
# RUN apt-get install helm