#!/bin/bash

mkdir -p /etc/systemd/system/containerd.service.d/
cat > /etc/systemd/system/containerd.service.d/http-proxy.conf <<-EOF
[Service]
Environment="HTTP_PROXY=http://${PROXY_IP}:1081"
Environment="HTTPS_PROXY=http://${PROXY_IP}:1081"
Environment="NO_PROXY=127.0.0.1,::1"
EOF

systemctl daemon-reload
systemctl restart containerd && systemctl enable --now containerd

set -e
apt-get install gawk -y

mkdir -p /etc/default
export PATH=$PATH:/sbin

export node_ip=$(ip addr | awk '/^[0-9]+: / {}; /inet.*global/ {print gensub(/(.*)\/(.*)/, "\\1", "g", $2)}' | grep 192.168.133.)
if [ ! -n ${node_ip} ]; then
	echo "not found node-ip"
	exit 1
fi
echo "KUBELET_EXTRA_ARGS=--node-ip=${node_ip}" >> /etc/default/kubelet
systemctl restart kubelet

kubeadm join ${MASTER_IP}:6443 --token ${TOKEN} --discovery-token-unsafe-skip-ca-verification
