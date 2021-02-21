#!/bin/bash

if [[ ! -z $VM_HOSTNAME ]]
then
  sudo hostnamectl set-hostname $VM_HOSTNAME
fi
