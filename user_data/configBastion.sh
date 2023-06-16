#!/bin/bash -x

# Variables
NsgBastionRuleSshPort="10022"

sudo apt -y update

# parcours du fichier sshd_config pour remplacer #Port 22 par Port 10022
sudo sed -i 's/#Port 22/Port "$NsgBastionRuleSshPort"/' /etc/ssh/sshd_config
sudo service sshd restart