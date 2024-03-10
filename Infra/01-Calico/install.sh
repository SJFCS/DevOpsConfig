Repo=https://docs.tigera.io/calico/charts
Chart=tigera-operator
Target=tigera-operator
NameSpace=tigera-operator
Version=v3.27.2

helm upgrade --install ${Target} ${Chart} \
  --repo ${Repo} \
  --namespace ${NameSpace} \
  --create-namespace \
  --version ${Version} \
  -f values.yaml 



# 作者：狼行天下
# 链接：https://www.orchome.com/9918
# 来源：OrcHome
# 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。

# 方式一：
# 从集群中每个节点获取 pod CIDR 地址。

# kubectl get nodes -o jsonpath='{.items[*].spec.podCIDR}'
# 方式二：
# kube-proxy所使用的 pod网络CIDR。

# kubectl cluster-info dump | grep -m 1 cluster-cidr
# 方式三：
# --cluster-cidr / --pod-network-cidr反馈给kube-controller-manager的配置。

# ps -ef | grep "cluster-cidr"
# 方式四：
# 在文件 /etc/kubernetes/manifests/kube-controller-manager.yaml 中的

# # sudo grep cidr /etc/kubernetes/manifests/kube-*
# /etc/kubernetes/manifests/kube-controller-manager.yaml:    - --allocate-node-cidrs=true
# /etc/kubernetes/manifests/kube-controller-manager.yaml:    - --cluster-cidr=192.168.0.0/16
# /etc/kubernetes/manifests/kube-controller-manager.yaml:    - --node-cidr-mask-size=24
# 方式五：
# 用kubeadm方式获取

# kubeadm config view | grep Subnet