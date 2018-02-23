#! /bin/bash

AWS_USER=$1
AWS_IP=$2
AWS_SSH_KEY=$3

echo "Step 01. Nginx installation"
ssh -i ${AWS_SSH_KEY} ${AWS_USER}@${AWS_IP} 'bash -s' < ./devops/nginx.sh

echo "Step 02. Jenkins installation"
ssh -i ${AWS_SSH_KEY} ${AWS_USER}@${AWS_IP} 'bash -s' < ./devops/jenkins.sh

echo "Step 03. Jenkins init settings"
ssh -i ${AWS_SSH_KEY} ${AWS_USER}@${AWS_IP} 'bash -s' < ./devops/jenkis_ci.sh