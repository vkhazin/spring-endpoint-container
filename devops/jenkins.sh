#!/usr/bin/env bash

# Install updates
sudo yum -y update

#Install wget tool
sudo yum install -y wget

# Jenkins depend on Java then install Java 8
sudo yum remove java-1.7.0-openjdk -y
sudo yum install -y java-1.8.0

# Need to add jenkins official repo. Needed for yum to know where get jenkins
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo

# Add Jenkins GPG key as trusted key
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key

# Install git
sudo yum install git -y

# Install Jenkins
echo "install jenkins"
sudo yum install jenkins -y

# Install docker
echo "install docker"
sudo yum install docker -y
sudo service docker start

# Add access rights
sudo groupadd docker
sudo usermod -a -G docker ec2-user # for ssh connecting
sudo usermod -a -G docker jenkins
sudo service docker restart

# Turn on to automatically Docker starting when instance is started
sudo chkconfig docker on

# Start Jenkins
sudo service jenkins start
sudo sleep 5  # Waits 5 seconds.
# Turn on to automatically Jenkins starting when instance is started
sudo chkconfig jenkins on

# Check that jenkins is up
echo "Jenkins via public ip = https://$(curl ifconfig.co -s)"
echo "Jenkins via public dns =  https://$(curl -s http://169.254.169.254/latest/meta-data/public-hostname)"
echo "Jenkins admin password: $(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)"



