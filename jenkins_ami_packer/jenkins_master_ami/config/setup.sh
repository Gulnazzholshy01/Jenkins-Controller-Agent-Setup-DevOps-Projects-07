#!/bin/bash

#set hostname
echo "Setting hostname"
sudo hostnamectl set-hostname jenkins-master

#install jenkins
echo "Installing Jenkins"
sudo apt update
sudo apt install openjdk-11-jdk -y
sleep 5
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
sleep 5
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]  https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sleep 5
sudo apt update
sleep 5
sudo apt install jenkins -y
sudo systemctl start jenkins

#install git
sudo apt-get install git -y


#set SSH key 
echo "Setup SSH key"
sudo mkdir /var/lib/jenkins/.ssh
sudo touch /var/lib/jenkins/.ssh/known_hosts
sudo chown -R jenkins:jenkins /var/lib/jenkins/.ssh
sudo chmod 700 /var/lib/jenkins/.ssh
sudo mv /tmp/id_rsa /var/lib/jenkins/.ssh/id_rsa
sudo chmod 600 /var/lib/jenkins/.ssh/id_rsa
sudo chown -R jenkins:jenkins /var/lib/jenkins/.ssh/id_rsa


#Configure Jenkins
echo "Configure Jenkins"
sudo mkdir -p /var/lib/jenkins/init.groovy.d
sudo mv /tmp/scripts/*.groovy /var/lib/jenkins/init.groovy.d/
sudo chown -R jenkins:jenkins /var/lib/jenkins/init.groovy.d
sudo systemctl start jenkins