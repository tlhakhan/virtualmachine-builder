#!/bin/bash

# Create SSH keys and authorized_keys file for admin user
su admin -l -c "mkdir -m 0700 ~/.ssh"
su admin -l -c "touch ~/.ssh/authorized_keys"
su admin -l -c "chmod 0600 ~/.ssh/authorized_keys"
