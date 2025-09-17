#!/bin/bash

dnf -y install dnf-plugins-core
dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

#growpart /dev/nvme0n1 4 #This is for t3.micro
sudo growpart /dev/xvda 4 #This is for t2.micro

sudo lvextend -L +20G /dev/RootVG/rootVol
sudo lvextend -L +10G /dev/RootVG/varVol

sudo xfs_growfs /
sudo xfs_growfs /var
