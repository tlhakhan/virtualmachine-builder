#!/bin/sh

# set hostname, it will be resolvable via dns
esxcli system settings advanced set -o /Misc/PreferredHostName -s $VM_HOSTNAME
esxcli system hostname set --host=$VM_HOSTNAME
