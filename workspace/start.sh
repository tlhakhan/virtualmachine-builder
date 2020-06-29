#!/bin/bash
set -e

# the var file named after the vm
VM_NAME=$1

if [[ -z $VM_NAME ]]
then
  echo "Provide a virtual machine name."
  exit 1
fi

packer validate --var-file /packer/var-files/$VM_NAME.json /packer/templates/vm.json

packer build --var-file /packer/var-files/$VM_NAME.json /packer/templates/vm.json
