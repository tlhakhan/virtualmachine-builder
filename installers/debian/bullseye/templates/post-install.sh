#!/bin/bash

# Add /usr/local/bin to the PATH
export PATH=$PATH:/usr/local/bin

# No password needed for privilege escalation
cat <<EOF > /etc/sudoers.d/{{ index .PackerVars "vm_username" }}
{{ index .PackerVars "vm_username" }} ALL=(ALL) NOPASSWD:ALL
EOF

# Add authorized_keys for root
test -d /root/.ssh || mkdir /root/.ssh
cat <<EOF > /root/.ssh/authorized_keys
{{ index .PackerVars "vm_ssh_public_key" }}
EOF
chmod 0700 /root/.ssh
chmod 0600 /root/.ssh/authorized_keys

# Add authorized_keys for {{ index .PackerVars "vm_username" }}
test -d /home/{{ index .PackerVars "vm_username" }}/.ssh || mkdir /home/{{ index .PackerVars "vm_username" }}/.ssh
cat <<EOF > /home/{{ index .PackerVars "vm_username" }}/.ssh/authorized_keys
{{ index .PackerVars "vm_ssh_public_key" }}
EOF
chmod 0700 /home/{{ index .PackerVars "vm_username" }}/.ssh
chmod 0600 /home/{{ index .PackerVars "vm_username" }}/.ssh/authorized_keys
chown --recursive {{ index .PackerVars "vm_username" }}:{{ index .PackerVars "vm_username" }} /home/{{ index .PackerVars "vm_username" }}/.ssh

# Install ansible
apt-get update
apt-get install -y python3-pip
pip3 install --upgrade pip
pip install --upgrade ansible
ansible-galaxy collection install --timeout 180 community.general
