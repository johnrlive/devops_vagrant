#!/bin/bash
# Author: John Rodriguez
# "set -x": will print a trace of simple commands and their arguments
# after they are expanded and before they are executed.
set -x

# Set variables as of 03-21-18
TERRAFORM_VERSION="0.11.5"
PACKER_VERSION="1.2.1"
DIST_VERSION="xenial"
USER="vagrant"

# Set up sudo with $USER variable
cat <<EOF > /etc/sudoers.d/${USER}
${USER} ALL=(ALL) NOPASSWD:ALL
EOF
chmod 0440 /etc/sudoers.d/${USER}
# Setup sudo to allow no-password for "sudo" commands
usermod -a -G sudo ${USER}

# Create a new ssh key
[[ ! -f /home/${USER}/.ssh/${USER}_key ]] \
&& mkdir -p /home/${USER}/.ssh \
&& ssh-keygen -f /home/${USER}/.ssh/${USER}_key -N '' \
&& chown -R ${USER}:${USER} /home/${USER}/.ssh

# Get Ubuntu updates
apt-get update -y && apt-get upgrade -y
# Install packages
apt-get install -y \
    ansible \
    unzip \
    wget \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

# Install Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get update -y
apt-get install -y docker-ce

# Add docker privileges
usermod -G docker ${USER}

# Install pip
pip install -U pip && pip3 install -U pip
if [[ $? == 127 ]]; then
    wget -q https://bootstrap.pypa.io/get-pip.py
    python get-pip.py
    python3 get-pip.py
fi

# Install command tools: awscli and ebcli
pip install -U awscli
pip install -U awsebcli

# Install terraform 
wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
&& unzip -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin \
&& rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Install Packer
wget -q https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip \
&& unzip -o packer_${PACKER_VERSION}_linux_amd64.zip -d /usr/local/bin \
&& rm packer_${PACKER_VERSION}_linux_amd64.zip

# Install my packages
apt-get install -y mc vim

# Last step clean 
apt-get clean

# Display installed versions
aws --version && eb --version && docker --version && terraform --version && echo 'Packer version:' && packer --version && ansible --version