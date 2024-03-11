# 步骤

## 1.kubectl apply --server-side -f prometheus/setup

## 2.kubectl wait --for condition=Established --all CustomResourceDefinition --namespace=monitoring

## 3.kubectl apply -f prometheus/

## 4.kubectl get all -n monitoring
