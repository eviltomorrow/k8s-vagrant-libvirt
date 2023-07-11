#!/bin/bash
set -e

# 初始化 kubeadm
kubeadm config images list --image-repository registry.aliyuncs.com/google_containers
kubeadm config images pull --image-repository registry.aliyuncs.com/google_containers
kubeadm init --config=/vagrant/conf/kubeadm.yml --upload-certs --ignore-preflight-errors=ImagePull

kubectl create -f /vagrant/conf/tigera-operator.yaml
kubectl create -f /vagrant/conf/custom-resources.yaml

# 配置用户
usermod -aG root vagrant
chmod u+w /etc/sudoers
cat >> /etc/sudoers <<EOF
vagrant ALL=(ALL) ALL
EOF
chmod u-w /etc/sudoers

# root
cat >> ~/.bashrc <<EOF
alias k='kubectl' 
source <(kubectl completion bash | sed s/kubectl/k/g)
EOF
echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> /etc/profile

# general
chmod 0644 /etc/kubernetes/admin.conf
su - vagrant <<EOF 
source /etc/profile
mkdir -p ~/.kube
cp /etc/kubernetes/admin.conf ~/.kube/config
echo "export KUBECONFIG=~/.kube/config" >> ~/.bashrc
echo "alias k='kubectl'" >> ~/.bashrc
EOF
chmod 0600 /etc/kubernetes/admin.conf
