helm repo add grafana https://grafana.github.io/helm-charts
kubectl create ns grafana
helm install grafana-for-amp grafana/grafana -n grafana