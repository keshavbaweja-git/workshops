#!/bin/bash

envsubst < eks-cluster-config.yaml | eksctl create cluster -f -


ROLE_NAME=$(aws eks describe-nodegroup --cluster-name mycluster1 --nodegroup-name nodegroup | jq -r '.nodegroup | select (.nodegroupName == "nodegroup") | .nodeRole')
echo "export ROLE_NAME=${ROLE_NAME}" | tee -a ~/.bash_profile

rolearn=$(aws cloud9 describe-environment-memberships --environment-id=$C9_PID | jq -r .memberships[0].userArn)

eksctl create iamidentitymapping \
--cluster mycluster1 \
--arn ${rolearn} \
--group system:masters \
--username admin1
