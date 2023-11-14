#!/bin/bash

# Create SSH keys and authorized_keys file for packer user
su packer -l -c "mkdir -m 0700 ~/.ssh"
su packer -l -c "touch ~/.ssh/authorized_keys"
su packer -l -c "chmod 0600 ~/.ssh/authorized_keys"

# Setup SSH CA
mkdir /etc/ssh/auth_principals
touch /etc/ssh/trusted_ssh_ca.pub

cat <<EOF >> /etc/ssh/sshd_config

# SSH CA configuration
AuthorizedPrincipalsFile /etc/ssh/auth_principals/%u
TrustedUserCAKeys /etc/ssh/trusted_ssh_ca.pub
EOF

# Setup auth principals file for packer user
echo packer > /etc/ssh/auth_principals/packer
