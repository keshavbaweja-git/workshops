#!/bin/bash

envsubst < eks-cluster-config.yaml | eksctl create cluster -f -

C9_ROLE_ARN=$(aws cloud9 describe-environment-memberships --environment-id=$C9_PID | jq -r .memberships[0].userArn)

eksctl create iamidentitymapping \
--cluster mycluster1 \
--arn ${C9_ROLE_ARN} \
--group system:masters \
--username admin1
