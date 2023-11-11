# 📖 README
This repo helps build virtual machines using Packer on VMware ESXi hosts.

- [x] Build VMs on a simple network with just DHCP and DNS
- [x] Doesn't use TFTP server for netbooting
- [x] Doesn't use a separate HTTP server
- [x] Gracefully handle CTRL+C
- [x] Build VMs in parallel, for instance `xargs -P4 ...`

**Requirements**
- vSphere 8.0 ESXi host with SSH access enabled.
- A control machine with `hashicorp/packer` binaries.

**Supported VM Builds**
status | os | version | machine specs
---| --- | --- | ---
👍 | debian | bookworm | 4 vCPU, 4 GiB vRAM, 100 GiB NVMe vDisk

# 🌱 Getting started
1. Run the `prepare_installers.yaml` Ansible playbook.
1. Create a `installers/overrides.pkrvars.hcl` file.  This file contains Packer variables that overrides default values.
1. Perform `make`, the `builder` binary will be placed at the root of the repository folder.
1. Run the `builder` binary.  Use `-h` flag to see the arguments needed.

## ⚙️ `overrides.pkrvars.hcl`
The `installers/overrides.pkrvars.hcl` file is used by the builder to pass in Packer variable values that overrides the default values.

```hcl2
#
# ESX variables
#
esx_server    = "" # ESX host
esx_username  = "" # ESX user with admin and SSH access
esx_password  = "" # ESX user password
esx_network   = "" # ESX virtual network name for the VM
esx_datastore = "" # ESX datastore name to place the VM's VMDK files
```

## 👏 Appendix
description | link 
--- | ---
iPXE CD used in the virtual machine build process | <https://github.com/tlhakhan/ipxe-iso>
hashicorp/packer releases | <https://github.com/hashicorp/packer/releases>
Install Packer doc | <https://learn.hashicorp.com/tutorials/packer/getting-started-install>
