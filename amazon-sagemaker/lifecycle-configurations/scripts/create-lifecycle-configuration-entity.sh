#!/bin/sh

set -eux

INSTALL_SCRIPT="on-jupyter-server-start.sh"
LCC_CONTENT=`openssl base64 -A -in $INSTALL_SCRIPT`
echo $LCC_CONTENT

aws sagemaker create-studio-lifecycle-config \
--studio-lifecycle-config-name install-on-jupyter-server-start \
--studio-lifecycle-config-content $LCC_CONTENT \
--studio-lifecycle-config-app-type JupyterServer

aws sagemaker update-user-profile --domain-id d-xcdufqe3gycr \
--user-profile-name keshavkb-3-1 \
--user-settings '{
"JupyterServerAppSettings": {
  "LifecycleConfigArns":
    ["arn:aws:sagemaker:ap-southeast-1:646297494209:studio-lifecycle-config/install-on-jupyter-server-start"]
  }
}'