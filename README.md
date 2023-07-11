# k8s-vagrant-libvirt
Kubernetes install with vagrant libvirt

# 准备

   安装 vagrant, libvirt

# 第一步

## git clone https://github.com/eviltomorrow/k8s-vagrant-libvirt.git

   进入目录，执行 vagrant up，等待安装完成

# 第二步

## master 节点执行

### 拉取镜像

```sh
kubeadm config images list --image-repository registry.aliyuncs.com/google_containers
kubeadm config images pull --image-repository registry.aliyuncs.com/google_containers
```

### 初始化 master 集群

```sh
kubeadm init --config=/vagrant/kubeadm.yml --upload-certs --ignore-preflight-errors=ImagePull
```

### 配置 sudoers

```sh
usermod -aG root vagrant

chmod u+w /etc/sudoers
vim /etc/sudoers
# 在文件内找到："root ALL=(ALL) ALL"在起下面添加XXX ALL=(ALL) ALL"
# (这里的XXX是我的用户名)，然后保存退出。

chmod u-w /etc/sudoers
```

### 添加到 profile

```sh
vim ~/.bashrc 添加如下内容：
alias k='kubectl' 
source <(kubectl completion bash | sed s/kubectl/k/g)

## general user
source /etc/profile
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
echo "export KUBECONFIG=$HOME/.kube/config" >> ~/.bashrc

## root user
echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> /etc/profile
```

### 查看 join 命令

```sh
kubeadm token create --print-join-command
```

## node 节点执行

### 加入 master

```sh
kubeadm join xxxxxx
```

### 重启一下所有节点
```sh
# 退出到本机终端，然后执行
vagrant halt
vagrant up
```
##

### 配置网络

```sh
kubectl create -f /vagrant/tigera-operator.yaml
kubectl create -f /vagrant/custom-resources.yaml
```

