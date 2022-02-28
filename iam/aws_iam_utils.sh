#!/bin/bash

function aws_create_user() {
user=$1
aws iam create-user --user-name ${user}
aws iam create-access-key --user-name ${user} | tee /tmp/${user}.json    
}

function aws_set_user() {
user=$1
export AWS_SECRET_ACCESS_KEY=$(jq -r .AccessKey.SecretAccessKey /tmp/$user.json)
export AWS_ACCESS_KEY_ID=$(jq -r .AccessKey.AccessKeyId /tmp/$user.json)
}

function aws_unset_user() {
unset AWS_SECRET_ACCESS_KEY
unset AWS_ACCESS_KEY_ID
}