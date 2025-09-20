#!/bin/bash

dnf -y install dnf-plugins-core
dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

sudo growpart /dev/nvme0n1 4 #This is for t3.micro
#sudo growpart /dev/xvda 4 #This is for t2.micro

sudo lvextend -L +20G /dev/RootVG/rootVol
sudo lvextend -L +10G /dev/RootVG/varVol

sudo xfs_growfs /
sudo xfs_growfs /var


ARCH=amd64
PLATFORM=$(uname -s)_$ARCH
sudo curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"
sudo tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz
sudo install -m 0755 /tmp/eksctl /usr/local/bin && rm /tmp/eksctl

sudo curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.33.0/2025-05-01/bin/linux/amd64/kubectl
sudo chmod +x ./kubectl
sudo mv kubectl /usr/local/bin/kubectl

eksctl version
kubectl version

sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens