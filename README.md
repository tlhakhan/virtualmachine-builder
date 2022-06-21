# 📖 README
This repo helps build virtual machines using packer on ESXi hosts.

- [x] Build on a simple network with DHCP and DNS. 
- [x] Doesn't use TFTP server for netbooting.
- [x] Doesn't use a separate HTTP server.
- [x] Built-in HTTP templating server.
- [x] Gracefully handle CTRL+C.

**Requirements**
- vSphere 7.0U3 ESXi host with SSH access enabled.
- A control machine with `ansible`, `hashicorp/packer` and `openssl` packages.

**Supported VM Builds**
status | os | version | machine specs
---| --- | --- | ---
👍 | centos | 8-stream | 4 vCPU, 4 GiB vRAM, 100 GiB NVMe vDisk
👍 | debian | bullseye | 4 vCPU, 4 GiB vRAM, 100 GiB NVMe vDisk
👍 | ubuntu | focal | 4 vCPU, 6 GiB vRAM, 100 GiB NVMe vDisk
👍 | ubuntu | jammy | 4 vCPU, 6 GiB vRAM, 100 GiB NVMe vDisk

# 🌱 Getting started
1. Setup the `installer_blobs` folder with vendor files.
1. Create a `config.yml` file.
1. Perform `make`, the `builder` binary will be placed repository root folder.
1. Run the `builder` binary.  Use `-h` flag to see the arguments needed.

## ⚙️ config.yml
The `config.yml` file is used by the builder to connect to a vSphere host to build VMs.

```yaml
---
build:
  server: vs-2  # ESX host
  user: builder # ESX user with admin permissions
  password: Secret123 # ESX user's password
  network: VM Network # virtual network to create the VM on
  datastore: nvme1 # the datastore to create the VM on

vm:
  user: sysuser # the VM user
  password: Welcome123 # the VM password

blob:
  dir: installer_blobs # the folder path of the vendor files
...
```

## Usage
```
Usage of ./builder:
  -c string
        Config file path.
  -n string
        Virtual machine name.
  -o string
        Operating system. Examples: debian, centos, ubuntu
  -r string
        Operating system release name. Examples: bullseye, 8-stream, focal, jammy
  -version
        Print program version.
```

## 👏 Appendix
description | link 
--- | ---
iPXE CD used in the virtual machine build process | <https://github.com/tlhakhan/ipxe-iso>
hashicorp/packer releases | <https://github.com/hashicorp/packer/releases>
Install Packer doc | <https://learn.hashicorp.com/tutorials/packer/getting-started-install>
