#!/bin/bash
sudo yum update -y
sudo yum install -y jq gettext bash-completion moreutils

pip install --upgrade pip
sudo pip uninstall awscli
echo "Uninstalled aws cli v1"


cd /tmp
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -qq awscliv2.zip
sudo ./aws/install --update
export PATH=$PATH:/usr/local/aws-cli/v2/current/bin
rm -rf /tmp/aws
rm -rf /tmp/awscliv2.zip
echo "Installed aws cli v2"

sudo curl --silent --location -o /usr/local/bin/kubectl \
https://dl.k8s.io/release/v1.22.0/bin/linux/amd64/kubectl
sudo chmod +x /usr/local/bin/kubectl
echo "Installed kubectl"

echo 'source <(kubectl completion bash)' >>~/.bashrc
echo 'alias k=kubectl' >>~/.bashrc
echo 'complete -F __start_kubectl k' >>~/.bashrc


curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv -v /tmp/eksctl /usr/local/bin
echo 'source <(eksctl completion bash)' >>~/.bashrc
echo "Installed eksctl"



pip install --user --upgrade boto3
