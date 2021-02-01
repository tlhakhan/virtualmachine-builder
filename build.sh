#!/bin/bash
set -e

# the var file 
VM_VAR_FILE=$1

if [[ -z $VM_VAR_FILE ]]
then
  echo "Provide a virtual machine var-file."
  echo "Usage: $0 [ vm var-file ]"
  exit 1
fi

if [[ -e .env ]]
then
  echo "Sourced .env file"
  source .env
else
  echo "ESX_BUILD_* environment variables not present. Run the setup_env.sh script."
  exit 1
fi

echo Validating virtual machine configuration for $VM_VAR_FILE.
packer validate --var-file $VM_VAR_FILE ./templates/vm.json

echo Performing virtual machine build for $VM_VAR_FILE.
packer build --var-file $VM_VAR_FILE ./templates/vm.json
