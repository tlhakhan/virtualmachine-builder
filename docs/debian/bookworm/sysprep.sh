#!/bin/bash

# Create SSH keys and authorized_keys file
ssh-keygen -N "" -q -f /home/packer/.ssh/id_rsa
touch /home/packer/.ssh/authorized_keys
chmod 0600 /home/packer/.ssh/authorized_keys
