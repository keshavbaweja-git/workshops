#!/bin/bash

for i in 'NGINX_POD_SG_ID' 'BUSYBOX_POD_SG_ID'
do
echo ${!i} ${NODE_GROUP_SG_ID}

aws ec2 authorize-security-group-ingress \
--group-id ${NODE_GROUP_SG_ID} \
--protocol tcp \
--port 53 \
--source-group ${!i}

aws ec2 authorize-security-group-ingress \
--group-id ${NODE_GROUP_SG_ID} \
--protocol udp \
--port 53 \
--source-group ${!i}
done

aws ec2 authorize-security-group-ingress \
--group-id ${NGINX_POD_SG_ID} \
--protocol tcp \
--port 80 \
--source-group ${BUSYBOX_POD_SG_ID}
