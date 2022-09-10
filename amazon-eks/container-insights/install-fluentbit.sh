#!/bin/bash

kubectl create ns amazon-cloudwatch

ClusterName=mycluster3
RegionName=ap-southeast-1
NodeGroupName=mng1
NodeIamRoleName=$(aws eks describe-nodegroup --cluster-name $ClusterName --nodegroup-name $NodeGroupName | jq -r .nodegroup.nodeRole | cut -d "/" -f 2)

aws iam attach-role-policy \
--role-name $NodeIamRoleName \
--policy-arn arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy

FluentBitHttpPort='2020'
FluentBitReadFromHead='Off'
[[ ${FluentBitReadFromHead} = 'On' ]] && FluentBitReadFromTail='Off'|| FluentBitReadFromTail='On'
[[ -z ${FluentBitHttpPort} ]] && FluentBitHttpServer='Off' || FluentBitHttpServer='On'

curl https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/master/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/fluent-bit/fluent-bit-configmap.yaml | sed 's/{{cluster_name}}/'${ClusterName}'/;s/{{region_name}}/'${RegionName}'/;s/{{http_server_toggle}}/"'${FluentBitHttpServer}'"/;s/{{http_server_port}}/"'${FluentBitHttpPort}'"/;s/{{read_from_head}}/"'${FluentBitReadFromHead}'"/;s/{{read_from_tail}}/"'${FluentBitReadFromTail}'"/' | kubectl apply -f -

curl https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/master/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/fluent-bit/fluent-bit.yaml | kubectl apply -f -