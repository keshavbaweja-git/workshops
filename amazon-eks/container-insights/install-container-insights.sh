#!/bin/bash

CLUSTER_NAME=mycluster5
NODEGROUP_NAME=mng1
NODE_ROLE_NAME=$(aws eks describe-nodegroup --nodegroup-name $NODEGROUP_NAME --cluster-name $CLUSTER_NAME | jq -r .nodegroup.nodeRole | cut -d "/" -f 2)

aws iam attach-role-policy \
--role-name $NODE_ROLE_NAME \
--policy-arn arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy

aws iam list-attached-role-policies \
--role-name $NODE_ROLE_NAME \
| grep CloudWatchAgentServerPolicy || echo 'Policy not found'


ClusterName=$CLUSTER_NAME
RegionName=ap-southeast-1
FluentBitHttpPort='2020'
FluentBitReadFromHead='Off'
[[ ${FluentBitReadFromHead} = 'On' ]] && FluentBitReadFromTail='Off'|| FluentBitReadFromTail='On'
[[ -z ${FluentBitHttpPort} ]] && FluentBitHttpServer='Off' || FluentBitHttpServer='On'
curl https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/quickstart/cwagent-fluent-bit-quickstart.yaml | sed 's/{{cluster_name}}/'${ClusterName}'/;s/{{region_name}}/'${RegionName}'/;s/{{http_server_toggle}}/"'${FluentBitHttpServer}'"/;s/{{http_server_port}}/"'${FluentBitHttpPort}'"/;s/{{read_from_head}}/"'${FluentBitReadFromHead}'"/;s/{{read_from_tail}}/"'${FluentBitReadFromTail}'"/' | kubectl apply -f -
echo "Installed Container Insights"
 