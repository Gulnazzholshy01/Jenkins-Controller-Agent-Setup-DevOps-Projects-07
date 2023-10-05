#!/bin/bash

#Set Hostname
sudo hostnamectl set-hostname jenkins-worker

#Install Java JRE 11"
echo "Installing Java JRE 11"
sudo apt-get update -y
sudo apt-get install openjdk-11-jre-headless -y 


#Install git
echo "Installing git"
sudo apt-get install git -y

#Create user for Jenkins Agent
sudo adduser --home /var/lib/jenkins --shell /bin/bash jenkins
sudo mkdir /var/lib/jenkins/.ssh
sudo touch /var/lib/jenkins/.ssh/authorized_keys
echo "COPY PUBLIC KEY" >> /var/lib/jenkins/.ssh/authorized_keys
sudo chown -R jenkins:jenkins /var/lib/jenkins/.ssh
sudo chmod 700 /var/lib/jenkins/.ssh
sudo chmod 600 /var/lib/jenkins/.ssh/authorized_keys

#Create a directory for Jenkins Agent to store workspaces
sudo mkdir /var/lib/jenkins/jenkins_slave
sudo chown -R jenkins:jenkins /var/lib/jenkins
sleep 3


#Install Terraform
echo "Installing Terraform"
sudo apt-get update -y
sleep 3
sudo apt-get install -y gnupg software-properties-common
sleep 3
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint
sleep 3
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list
sleep 3
sudo apt-get update -y 
sudo apt-get install terraform -y
sleep 3

#Install Packer 
echo "Installing Packer"
sudo apt-get update -y
sleep 3
sudo apt -y install apt-transport-https ca-certificates curl software-properties-common
sleep 3
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/hashicorp.gpg
sleep 3
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" -y
sleep 3
sudo apt-get update -y
sudo apt-get install packer -y
sleep 3

#Install Ansible 
echo "Installing Ansible"
sudo apt-get update -y
sudo apt-add-repository ppa:ansible/ansible -y
sudo apt-get install ansible -y
sleep 3

#Install AWS CLI
echo "Installing awscli"
sudo apt-get install awscli -y