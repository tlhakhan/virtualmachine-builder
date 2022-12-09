# README
This folder stores the templates and files necessary for the installation of operating systems.

The `packer_template.pkr.hcl` is the generic Packer template and default variables used by the virtual machine `builder` binary.  The default Packer variables are overridden as necessary.  For instance, there are `virtual_machine.pkrvars.hcl` files that overrides specific variables pertaining to things like default CPU, memory, disk size and VMware guest OS type.

The `overrides.pkrvars.hcl` contains the Packer variable definitions that are needed to connect to the VMware ESXi host.  The variables `vm_username`, `vm_password`, `vm_linux_distro` and `vm_linux_distro_release` cannot be overriden by the `overrides.pkrvars.hcl` file because the `builder` binary will override them by the use of values provided to its flags.

The Operating System folder is structured as follows:

| File | Description |
| -- | -- | 
`<os-name>/<os-release>/virtual_machine.pkrvars.hcl` | Operating system release specific Packer variable overrides.
`<os-name>/<os-release>/playbook.yaml` | Ansible playbook to run on the virtual machine.
`<os-name>/<os-release>/inventory` | Ansible playbook inventory.
`<os-name>/<os-release>/templates` | Every file is processed as a Go `text/template` upon request, passing in the `templateVars` struct to the template on execution.
`<os-name>/<os-release>/files` | A directory to store non-template files, such as ISOs, initrd or other files needed during the pre|installation (iPXE) phase.
`<os-name>/<os-release>/files/download_list.txt` | A file that contains a list of URLs that will be used to populate the files directory by the `prepare_installers.yaml` Ansible playbook.
