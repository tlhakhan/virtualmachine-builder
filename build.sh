#!/bin/bash
set -e

VM_TEMPLATE_FILEPATH=$1
VM_HOSTNAME=$2

if [[ -z $VM_TEMPLATE_FILEPATH || -z $VM_HOSTNAME ]]
then
  echo "Usage: $0 [ vm template file ] [ vm name ]"
  exit 1
fi

if [[ -e .env ]]
then
  echo "Sourced local .env file"
  source .env
else
  echo "ESX_BUILD_* environment variables not present. Run the setup_env.sh script."
  exit 1
fi

WORKDIR=$PWD
VM_TEMPLATE_FOLDER=$(dirname $VM_TEMPLATE_FILEPATH)
VM_TEMPLATE_FILE=$(basename $VM_TEMPLATE_FILEPATH)

cd $VM_TEMPLATE_FOLDER
echo Validating virtual machine configuration for $VM_TEMPLATE_FILEPATH.
packer validate --var="vm_hostname=${VM_HOSTNAME}" $VM_TEMPLATE_FILE
echo Performing virtual machine build for $VM_TEMPLATE_FILEPATH.
packer build --var="vm_hostname=${VM_HOSTNAME}" $VM_TEMPLATE_FILE
cd $WORKDIR
