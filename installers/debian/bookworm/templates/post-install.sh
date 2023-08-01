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

# Allow SSH via public keys signed by a trusted SSH CA
cat <<EOF > /etc/ssh/trusted-ca.pem
{{ index .PackerVars "vm_ssh_ca_public_key" }}
EOF

mkdir /etc/ssh/auth_principals
echo root > /etc/ssh/auth_principals/root
echo {{ index .PackerVars "vm_username" }} > /etc/ssh/auth_principals/{{ index .PackerVars "vm_username" }}

cat <<EOF >> /etc/ssh/sshd_config
AuthorizedPrincipalsFile /etc/ssh/auth_principals/%u
KbdInteractiveAuthentication no
PasswordAuthentication yes
TrustedUserCAKeys /etc/ssh/trusted-ca.pem
EOF

# Install ansible
apt-get update
apt-get install -y python3-pip
pip3 install --upgrade pip
pip install --upgrade ansible
ansible-galaxy collection install --timeout 180 community.general

# Add net.ifnames=0 to the kernel boot parameters
sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT="\(.*\)"/GRUB_CMDLINE_LINUX_DEFAULT="\1 net.ifnames=0"/' /etc/default/grub
update-grub
