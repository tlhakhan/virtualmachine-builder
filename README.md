# 📖 README
This repo helps build virtual machines using Hashicorp Packer on [VMware Fusion Player](https://customerconnect.vmware.com/en/evalcenter?p=fusion-player-personal-13).

- [x] Build VMs on a simple network with just DHCP and DNS
- [x] Doesn't use TFTP server for netbooting
- [x] Doesn't use a separate HTTP server
- [x] Build VMs in parallel

**Requirements**
- VMware Fusion Player 13 or higher.
- A MacOS control machine with `hashicorp/packer` binaries.
- MacOS host machine using M1, M2 or M3 processor.

**Supported VM Builds**
status | arch | os | version | machine specs
---| --- | --- | --- | ---
👍 | arm64 | debian | bookworm | 2 vCPU, 2 GiB vRAM, 40 GiB vDisk

# 🌱 Getting started
1. Create an `overrides.pkrvars.hcl` file.  See example below.
1. Run the `builder.sh` script.  Provide virtual machine name as argument.

## ⚙️ Example overrides.pkrvars.hcl file
The `overrides.pkrvars.hcl` file is not tracked by git, it is used to override default values in the `packer_template.pkr.hcl` variables.

```hcl
# VM config
vm_cpus        = 2
vm_memory      = 2048
vm_disk_size   = 40960
vm_datastore   = "/VirtualMachines"
vm_username    = "debian"
vm_password    = "debian"
ssh_public_key = "ssh-ed25519 ..."
```

## 👏 Appendix
description | link 
--- | ---
hashicorp/packer releases | <https://github.com/hashicorp/packer/releases>
vmware-iso builder | <https://developer.hashicorp.com/packer/integrations/hashicorp/vmware/latest/components/builder/iso>
