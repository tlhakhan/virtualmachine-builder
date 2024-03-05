# 📖 README
This repo helps build virtual machines using Packer on VMware Workstation Pro.

- [x] Build VMs on a simple network with just DHCP and DNS
- [x] Doesn't use TFTP server for netbooting
- [x] Doesn't use a separate HTTP server
- [x] Gracefully handle CTRL+C
- [x] Build VMs in parallel

**Requirements**
- VMware Workstation Pro 17.5 or higher.
- A control machine with `hashicorp/packer` binaries.

**Supported VM Builds**
status | os | version | machine specs
---| --- | --- | ---
👍 | debian | bookworm | 4 vCPU, 4 GiB vRAM, 40 GiB vDisk

# 🌱 Getting started
1. Create an `overrides.pkrvars.hcl` file.  See example below.
1. Run the `builder.sh` script for Linux or `builder.ps1` script for Windows.  Provide virtual machine name as argument.

## ⚙️ Example overrides.pkrvars.hcl file
The `overrides.pkrvars.hcl` file is not tracked by git, it is used to override default values in the `packer_template.pkr.hcl` variables.

```hcl
# VM configuration
vm_cpus           = 4
vm_memory         = 4096
vm_disk_size      = 40960
vm_disk_directory = "/datastore"

# SSH details
ssh_public_key    = "" # SSH key to inject
ssh_ca_public_key = "" # SSH CA key to trust
```

## 👏 Appendix
description | link 
--- | ---
iPXE CD used in the virtual machine build process | <https://github.com/tlhakhan/ipxe-iso>
hashicorp/packer releases | <https://github.com/hashicorp/packer/releases>