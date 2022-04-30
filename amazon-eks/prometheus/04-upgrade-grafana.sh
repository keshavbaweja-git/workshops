helm upgrade --install grafana-for-amp grafana/grafana \
-n grafana \
-f ./amp_query_override_values.yaml