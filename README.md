# k8s-vagrant-libvirt

   Kubernetes install with vagrant libvirt

# 准备

   安装 vagrant, libvirt

# 安装

   git clone https://github.com/eviltomorrow/k8s-vagrant-libvirt.git


# 启用 CNI

   - 使用 calico，打开 sh/master.sh 下最后两行的注释， 进入目录，执行 vagrant up，等待安装完成

   ```sh
   # kubectl create -f /vagrant/conf/tigera-operator.yaml
   # kubectl create -f /vagrant/conf/custom-resources.yaml
   ```

   - 使用 clilium，请按如下操作

   ```sh
   1、进入目录，执行 vagrant up，等待安装完成

   2、
      # cilium的cli工具是一个二进制的可执行文件
      $ tar zxvfC /vagrant/bin/cilium-linux-amd64.tar.gz /usr/local/bin/  

      # 使用该命令即可完成cilium的安装
      $ cilium install

      # 我们先使用cilium-cli工具在k8s集群中部署hubble，只需要下面一条命令即可
      $ cilium hubble enable

      # 安装hubble-cli工具，安装逻辑和cilium-cli的逻辑相似
      $ tar xzvfC hubble-linux-amd64.tar.gz /usr/local/bin

      # 首先我们要开启hubble的api，使用cilium-cli开启转发
      $ cilium hubble port-forward&

      # 测试 cilium 状态
      $ cilimu status

      # 测试和hubble-api的连通性
      $ hubble status

      # 使用hubble命令查看数据的转发情况
      $ hubble observe

      # 开启hubble ui组件
      $ cilium hubble enable --ui

      # 实际上这时候我们再查看k8s集群的状态可以看到部署了一个名为hubble-ui的deployment
      $ kubectl get deployment -n kube-system | grep hubble
      $ kubectl get svc -n kube-system | grep hubble

      # 将hubble-ui这个服务的80端口暴露到宿主机上面的12000端口上面
      $ cilium hubble ui&
   ```

