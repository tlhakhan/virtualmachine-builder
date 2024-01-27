#!/bin/bash

# Export required variables
PKR_VAR_vm_name="$1"

if [[ -z $PKR_VAR_vm_name ]]
then
  echo Usage: "$0" [ vm name ]
  exit 1
fi

if [[ ! -e "overrides.pkrvars.hcl" ]]
then
  echo Error:
  echo   Missing overrides.pkrvars.hcl file.  See README.md for more details.
  exit 1
fi 

# Run packer
export PKR_VAR_vm_name
packer init packer_template.pkr.hcl
packer validate -var-file overrides.pkrvars.hcl packer_template.pkr.hcl
packer build -var-file overrides.pkrvars.hcl packer_template.pkr.hcl
