#!/bin/bash
set -e

# the var file named after the vm
VM_NAME=$1

if [[ -z $VM_NAME ]]
then
  echo "Provide a virtual machine name."
  exit 1
fi

echo Validating virtual machine configuration for $VM_NAME.
packer validate --var-file /packer/var-files/$VM_NAME.json /packer/templates/vm.json
echo Performing virtual machine build for $VM_NAME.
packer build --var-file /packer/var-files/$VM_NAME.json /packer/templates/vm.json
