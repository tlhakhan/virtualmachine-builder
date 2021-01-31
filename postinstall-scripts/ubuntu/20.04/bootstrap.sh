#!/bin/bash

if [[ ! -z $VM_HOSTNAME ]]
  hostnamectl --set-hostname $VM_HOSTNAME
fi
