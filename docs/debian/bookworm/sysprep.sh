#!/bin/bash

# Create SSH keys and authorized_keys file for packer user
su packer -l -c "mkdir -m 0700 ~/.ssh"
su packer -l -c "touch ~/.ssh/authorized_keys"
su packer -l -c "chmod 0600 ~/.ssh/authorized_keys"