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
👍 | debian | bookworm | 2 vCPU, 4 GiB vRAM, 20 GiB NVMe vDisk

# 🌱 Getting started
1. Create an `overrides.pkrvars.hcl` file.  See example below.
1. Run the `builder.sh` script.  Provide virtual machine name as argument.

## ⚙️ Example overrides.pkrvars.hcl file
The `overrides.pkrvars.hcl` file is not tracked by git, this file used to provide required inputs such as ESXi server configuration and override default VM instance size configuration.

```hcl
#
# ESX config
#
esx_server    = "" # ESX host
esx_username  = "" # ESX user with admin and SSH access 
esx_password  = "" # ESX user password
esx_datastore = "" # ESX datastore name to place the VM's disk files

#
# VM config
#
vm_cpus      = 2
vm_memory    = 4096
vm_disk_size = 20480
vm_network   = "VM Network"
```

## 👏 Appendix
description | link 
--- | ---
iPXE CD used in the virtual machine build process | <https://github.com/tlhakhan/ipxe-iso>
hashicorp/packer releases | <https://github.com/hashicorp/packer/releases>