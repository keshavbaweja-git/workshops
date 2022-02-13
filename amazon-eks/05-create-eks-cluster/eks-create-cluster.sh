#!/bin/bash

envsubst < eks-cluster-config.yaml | eksctl create cluster -f -


ROLE_NAME=$(aws eks describe-nodegroup --cluster-name mycluster1 --nodegroup-name nodegroup | jq -r '.nodegroup | select (.nodegroupName == "nodegroup") | .nodeRole')
echo "export ROLE_NAME=${ROLE_NAME}" | tee -a ~/.bash_profile