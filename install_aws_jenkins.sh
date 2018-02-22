#!/usr/bin/env bash

echo "Step 01. Nginx initialization"
sh ./devops/nginx.sh

echo "Step 02. Jenkins initialization"
sh ./devops/jenkins.sh

echo "Step 03. Jenkins for docker image build"
sh ./devops/jenkins_ci.sh