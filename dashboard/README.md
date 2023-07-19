# 安装 Dashboard

- 确认 recommended.yaml 中的 service 的 type 为 NodePort

- 执行 kubectl create -f recommended.yaml

- 执行 kubectl create -f service-role.yaml

- 执行 kubectl create -f service-account.yaml

# 浏览器访问

- 执行 k get svc -n kubernetes-dashboard，查看 NodePort 的端口 

- 浏览器访问 https://${NodeIP}:${NodePort}

- 获取 token, 执行 k -n kubernetes-dashboard create token admin-user




