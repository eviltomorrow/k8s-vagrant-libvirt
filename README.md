# k8s-vagrant-libvirt

   Kubernetes install with vagrant libvirt

# 准备

   安装 vagrant, libvirt

# 安装

   git clone https://github.com/eviltomorrow/k8s-vagrant-libvirt.git


# 启用 CNI

   - 使用 calico，打开 # calico 下最后两行的注释， 进入目录，执行 vagrant up，等待安装完成

   ```sh
   # kubectl create -f /vagrant/conf/tigera-operator.yaml
   # kubectl create -f /vagrant/conf/custom-resources.yaml
   ```

   - 使用 clilium，打开 # calico 下最后两行的注释， 进入目录，执行 vagrant up，等待安装完成(耗时长)

   ```sh
   # mkdir -p /usr/local/app/helm; tar zxvfC /vagrant/bin/helm-v3.12.2-linux-amd64.tar.gz /usr/local/app/helm; ln -s /usr/local/app/helm/linux-amd64/helm /usr/local/bin/helm
   # helm repo add cilium https://helm.cilium.io
   # kubectl create namespace cilium-system
   # helm install cilium cilium/cilium --namespace cilium-system --set hubble.relay.enabled=true --set hubble.ui.enabled=true --set prometheus.enabled=true --set operator.prometheus.enabled=true --set hubble.enabled=true --set hubble.metrics.enabled="{dns,drop,tcp,flow,port-distribution,icmp,http}"
   ```

