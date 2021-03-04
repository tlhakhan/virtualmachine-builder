# 📖 README
This repo helps build virtual machines using packer on ESXi hosts.

- [x] Build on a simple network with DHCP and DNS. 
- [x] Doesn't use TFTP server for netbooting.
- [x] Doesn't use a separate HTTP server.
- [x] Built-in HTTP templating server.
- [x] Build a working container.
- [x] Gracefully handle CTRL+C.

**Requirements**
- vSphere 6.7u3 or 7.0b ESXi host with SSH enabled.

**Supported VM Builds**
status | os | version | machine specs
---| --- | --- | ---
👍 | debian | 10.7 | 8 vCPU, 8 GiB vRAM, 100 GiB NVMe vDisk
👍 | ubuntu | 20.04 | 8 vCPU, 8 GiB vRAM, 100 GiB NVMe vDisk
👍 | vsphere | 6.7u3 | 8 vCPU, 32 GiB vRAM, 100 GiB NVMe vDisk
👍 | vsphere | 7.0b | 8 vCPU, 32 GiB vRAM, 100 GiB NVMe vDisk

# 🌱 Getting started
1. Setup the `blob` folder with vendor files.  See `README.md` located inside of folder.
1. Run `mount_iso_folders.sh` to mount ISO files to a path local `iso_contents` folder.
1. Create a `config.yml` file.
1. Run `build.sh` script with extra arguments `-o`, `-v`, and `-n`.
1. The script will build a container image and map `config.yml`, `blob` directory into the container.
1. The script will launch the virtual machine build process.

## ⚙️ config.yml
The `config.yml` file is used by the virtual machine build process.

```yaml
---
build:
  server: vsphere-1  # ESX host
  user: builder # ESX user with admin permissions
  password: password # ESX user's password
  network: VM Network # virtual network to create the VM on
  datastore: nvme1 # the datastore to create the VM on

vm:
  user: guest # the VM user
  password: password # the VM password

blob:
  dir: blob # the folder path of the vendor files
  
...
```

### 🥅 TODOs
[] Use Makefile.
[] Handle `*.iso` mount and unmount without helper scripts.

## 👏 Appendix
description | link 
--- | ---
iPXE CD used in the virtual machine build process | <https://github.com/tlhakhan/ipxe-iso>
