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
1. Create an `overrides.pkrvars.hcl` file. See example `overrides.pkrvars.hcl.example`.
1. Run the `builder.sh` script.

## 👏 Appendix
description | link 
--- | ---
iPXE CD used in the virtual machine build process | <https://github.com/tlhakhan/ipxe-iso>
hashicorp/packer releases | <https://github.com/hashicorp/packer/releases>
Install Packer doc | <https://learn.hashicorp.com/tutorials/packer/getting-started-install>
