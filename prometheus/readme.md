安装步骤：

- helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

- kubectl create ns monitoring

- helm install prometheus-community/kube-prometheus-stack --namespace monitoring --generate-name

查看 grafana 密码

- kubectl get secret --namespace monitoring kube-prometheus-stack-1752566437-grafana -o jsonpath="{.data.admin-password}" | base64 --decode; echo

prom-operator

参考： https://www.wake.wiki/archives/eks-tong-guo-helm-an-zhuang-kube-prometheus-stack-wan-cheng-dui-ji-qun-zhuang-tai-de-jian-kong