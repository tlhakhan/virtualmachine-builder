#!/bin/bash

# Create SSH keys and authorized_keys file for packer user
su packer -l -c "ssh-keygen -N '' -q -f ~/.ssh/id_rsa"
su packer -l -c "touch ~/.ssh/authorized_keys"
su packer -l -c "chmod 0600 ~/.ssh/authorized_keys"
