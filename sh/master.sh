#!/bin/bash
set -e

# 初始化 kubeadm
kubeadm config images list --image-repository registry.aliyuncs.com/google_containers
kubeadm config images pull --image-repository registry.aliyuncs.com/google_containers
kubeadm init --config=/vagrant/conf/kubeadm.yml --upload-certs --ignore-preflight-errors=ImagePull

# 配置用户
usermod -aG root vagrant
chmod u+w /etc/sudoers
cat > /etc/sudoers.d/vagrant <<EOF
vagrant ALL=(ALL) NOPASSWD:ALL
EOF
chmod u-w /etc/sudoers

# root
cat >> ~/.bashrc <<EOF
alias k='kubectl' 
source <(kubectl completion bash | sed s/kubectl/k/g)
export KUBECONFIG=/etc/kubernetes/admin.conf
EOF
echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> /etc/profile
source /etc/profile
source ~/.bashrc

# general
chmod 0644 /etc/kubernetes/admin.conf
su - vagrant <<EOF 
source /etc/profile
mkdir -p ~/.kube
cp /etc/kubernetes/admin.conf ~/.kube/config
echo "export KUBECONFIG=~/.kube/config" >> ~/.bashrc
echo "alias k='kubectl'" >> ~/.bashrc
echo "source <(kubectl completion bash | sed s/kubectl/k/g)" >> ~/.bashrc
EOF
chmod 0600 /etc/kubernetes/admin.conf

# 使用 calico
# kubectl create -f /vagrant/conf/tigera-operator.yaml
# kubectl create -f /vagrant/conf/custom-resources.yaml

# 使用 cilium
mkdir -p /usr/local/app/helm; tar zxvfC /vagrant/bin/helm-v3.13.0-linux-amd64.tar.gz /usr/local/app/helm; ln -s /usr/local/app/helm/linux-amd64/helm /usr/local/bin/helm
helm repo add cilium https://helm.cilium.io
kubectl create namespace cilium-system
helm install cilium cilium/cilium --namespace cilium-system --set hubble.relay.enabled=true --set hubble.ui.enabled=true --set prometheus.enabled=true --set operator.prometheus.enabled=true --set hubble.enabled=true --set hubble.metrics.enabled="{dns,drop,tcp,flow,port-distribution,icmp,http}"
