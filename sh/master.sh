#!/bin/bash
set -e

export PATH=$PATH:/sbin

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
mkdir -p /usr/local/app/helm; tar zxvfC /vagrant/bin/helm-v3.17.1-linux-amd64.tar.gz /usr/local/app/helm; ln -s /usr/local/app/helm/linux-amd64/helm /usr/local/bin/helm


export proxy="http://${PROXY_IP}:1081"
export http_proxy=$proxy
export https_proxy=$proxy
export no_proxy="localhost, 127.0.0.1, ::1"

helm repo add cilium https://helm.cilium.io

unset proxy
unset http_proxy
unset https_proxy
# kubectl create namespace cilium-system

target_device=""
for device in $(ip link | grep -E '^[0-9]' | awk '-F: ' '{print $2}'); do
    count=$(ip addr show ${device} | grep ${MASTER_IP} | wc -l)
    if [ ${count} == "1" ]; then
        target_device=${device}
        break
    fi
done

helm install cilium cilium/cilium --namespace cilium-system --set hubble.relay.enabled=true --set hubble.ui.enabled=true --set prometheus.enabled=true --set operator.prometheus.enabled=true --set devices=${target_device} --set hubble.enabled=true --set hubble.metrics.enabled="{dns,drop,tcp,flow,port-distribution,icmp,http}"
