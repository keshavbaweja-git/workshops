#!/bin/bash

NODE_ROLE_ARN=$(aws eks describe-nodegroup --cluster-name mycluster1 --nodegroup-name nodegroup | jq -r '.nodegroup | select (.nodegroupName == "nodegroup") | .nodeRole')
echo "export NODE_ROLE_ARN=${NODE_ROLE_ARN}" | tee -a ~/.bash_profile

NODE_ROLE_NAME=$(aws eks describe-nodegroup --cluster-name mycluster1 --nodegroup-name nodegroup | jq -r '.nodegroup | select (.nodegroupName == "nodegroup") | .nodeRole' | cut -f2 -d '/')
echo "export NODE_ROLE_NAME=${NODE_ROLE_NAME}" | tee -a ~/.bash_profile