#!/bin/bash

# Prompt the user for the name of the virtual machine
read -p "Name of virtual machine? " vm_name

# Export required variables
export PKR_VAR_vm_name="$vm_name"

if [[ ! -e "overrides.pkrvars.hcl" ]]
then
  echo
  echo Missing overrides.pkrvars.hcl file.  See README.md for more details.
  exit 1
fi 

# Run packer
packer validate -var-file overrides.pkrvars.hcl packer_template.pkr.hcl
packer build -var-file overrides.pkrvars.hcl packer_template.pkr.hcl
