## install
kubeadm config print init-defaults --kubeconfig ClusterConfiguration > kubeadm.yml
kubeadm config migrate --old-config kubeadm.yml --new-config new.yaml

kubeadm init phase preflight --config kubeadm.yaml
kubeadm config images list --config kubeadm.yml
kubeadm config images pull --config kubeadm.yml

sudo kubeadm init --config kubeadm.yml --upload-certs

kubectl taint nodes archlinux  node-role.kubernetes.io/control-plane:NoSchedule-

## clean

sudo sh -c '
kubeadm reset -f
ipvsadm --clear
rm -rf ~/.kube
rm -rf /etc/cni/net.d
rm -rf /etc/kubernetes/
rm -rf /opt/cni
rm -rf /var/lib/etcd
'
rm -rf $HOME/.kube/config