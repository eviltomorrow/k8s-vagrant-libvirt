#!/bin/bash

set -e
apt-get install gawk -y

mkdir -p /etc/default
export PATH=$PATH:/sbin

node_ip=$(ip addr | awk '/^[0-9]+: / {}; /inet.*global/ {print gensub(/(.*)\/(.*)/, "\\1", "g", $2)}' | grep 192.168.133.)
echo ${node_ip}
if [ ! -n ${node_ip} ]; then
	echo "not found node-ip"
	exit 1
fi
echo "KUBELET_EXTRA_ARGS=--node-ip=${node_ip}" >> /etc/default/kubelet
systemctl restart kubelet

kubeadm join ${MASTER_IP}:6443 --token ${TOKEN} --discovery-token-unsafe-skip-ca-verification
