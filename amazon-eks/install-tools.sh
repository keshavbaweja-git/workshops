#!/bin/bash
sudo yum update -y
sudo yum install -y jq gettext bash-completion moreutils

pip install --upgrade pip
sudo pip uninstall awscli
echo "Uninstalled aws cli v1"


cd /tmp
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
export PATH=$PATH:/usr/local/aws-cli/v2/current/bin
rm -rf /tmp/aws
rm -rf /tmp/awscliv2.zip
echo "Installed aws cli v2"

pip install --user --upgrade boto3
