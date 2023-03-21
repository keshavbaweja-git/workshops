helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add kube-state-metrics https://kubernetes.github.io/kube-state-metrics
helm repo update

kubectl create ns prometheus

helm install prometheus-for-amp \
prometheus-community/prometheus -n prometheus \
-f my_prometheus_values_yaml
