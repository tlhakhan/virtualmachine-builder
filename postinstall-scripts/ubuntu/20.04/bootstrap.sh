#!/bin/bash

if [[ ! -z $VM_HOSTNAME ]]
then
  hostnamectl set-hostname $VM_HOSTNAME
fi
