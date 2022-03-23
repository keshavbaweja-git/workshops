#!/bin/bash
sudo yum update -y -q
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

cd /tmp
wget https://dlcdn.apache.org/maven/maven-3/3.8.5/binaries/apache-maven-3.8.5-bin.tar.gz
tar -C ~/environment/ -xvzf apache-maven-3.8.5-bin.tar.gz
echo "PATH=$PATH:$HOME/environment/apache-maven-3.8.5/bin" >> ~/.bash_profile
source ~/.bash_profile
rm /tmp/apache-maven-3.8.5-bin.tar.gz
echo "Installed Maven"
mvn -v

npm install -g aws-cdk
echo "Installed CDK"
cdk --version

ACCOUNT_ID=$(aws sts get-caller-identity --output text --query Account)
AWS_REGION=$(curl -s 169.254.169.254/latest/dynamic/instance-identity/document | jq -r '.region')
echo "export ACCOUNT_ID=${ACCOUNT_ID}" | tee -a ~/.bash_profile
echo "export AWS_REGION=${AWS_REGION}" | tee -a ~/.bash_profile
source ~/.bash_profile

cdk bootstrap aws://${ACCOUNT_ID}/${AWS_REGION}
echo "Bootstrapped CDK"
