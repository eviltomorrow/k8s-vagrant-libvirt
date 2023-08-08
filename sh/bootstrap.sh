#!/bin/bash 

echo "Setup base env"
export DEBIAN_FRONTEND=noninteractive

cat > /etc/apt/sources.list << EOF
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm main contrib non-free-firmware non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-proposed-updates non-free-firmware contrib non-free main
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-updates main non-free-firmware non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-backports main contrib non-free-firmware non-free
EOF

apt-get update -y
apt-get dist-upgrade -y
apt-get autoremove

echo "export PATH=$PATH:/sbin" > ~/.bashrc
source ~/.bashrc

swapoff -a && sed -ri 's/.*swap.*/#&/' /etc/fstab

# systemctl stop ufw.service && systemctl disable --now ufw.service
# systemctl stop firewalld.service && systemctl disable --now firewalld.service
# setenforce 0; sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

# systemctl enable --now chronyd
systemctl restart rsyslog
systemctl start chronyd

timedatectl set-timezone Asia/Shanghai
timedatectl set-local-rtc 0


cat >> /etc/hosts <<EOF
192.168.133.100 master
192.168.133.200 node01
192.168.133.201 node02
EOF

cat <<EOF | tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

# Setup required sysctl params, these persist across reboots.
cat <<EOF | tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

# Apply sysctl params without reboot
sysctl --system

# install crontainerd.io
for pkg in docker.io docker-doc docker-compose containerd runc; do apt-get remove $pkg; done
apt-get update
apt-get install -y ca-certificates curl gnupg vim
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install containerd.io -y
mkdir -p /etc/containerd; cp /vagrant/conf/config.toml /etc/containerd/config.toml
systemctl restart containerd && systemctl enable --now containerd

# install kubernetes
apt-get update
apt-get install -y apt-transport-https ca-certificates curl
curl -fsSL https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://mirrors.tuna.tsinghua.edu.cn/kubernetes/apt/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list
apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl
systemctl enable kubelet && systemctl restart kubelet