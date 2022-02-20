#!/bin/bash

for i in 'NGINX_POD_SG' 'BUSYBOX_POD_SG'
do
echo $i
aws ec2 create-security-group \
--description $i \
--group-name $i \
--vpc-id ${VPC_ID}
done
