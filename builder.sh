#!/bin/bash

# Prompt the user for the name of the virtual machine
read -p "Name of virtual machine? " vm_name

# Display the entered virtual machine name
echo "You entered: $vm_name"

# Export required variables
export PKR_VAR_vm_name="$vm_name"

# Run packer
packer validate -var-file overrides.pkrvars.hcl packer_template.pkr.hcl
packer build -var-file overrides.pkrvars.hcl packer_template.pkr.hcl
