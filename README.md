# 📖 READ ME
This repo helps build virtual machines using packer on ESXi hosts.

- [x] Build on a simple network with a basic DHCP server, no need for additional configuration. 
- [x] Doesn't use TFTP server for netbooting.
- [x] Doesn't use a separate HTTP server.
- [x] Built-in HTTP templating server.
- [x] Build a working container.
- [x] Gracefully handle CTRL+C.

**Pre-requisites**
- vSphere 6.7u3 or 7.0b ESXi host with SSH enabled.

**Supported VM Builds**
status | os | version | machine specs
---| --- | --- | ---
👍 | debian | 10.7 | 8 vCPU, 8 GiB vRAM, 100 GiB NVMe vDisk
👍 | ubuntu | 20.04 | 8 vCPU, 8 GiB vRAM, 100 GiB NVMe vDisk
👍 | vsphere | 6.7u3 | 8 vCPU, 32 GiB vRAM, 100 GiB NVMe vDisk
👍 | vsphere | 7.0b | 8 vCPU, 32 GiB vRAM, 100 GiB NVMe vDisk

# 🌱 Getting started
1. Setup the `blob` folder with vendor files.
1. Run `mount_iso_folders.sh` to mount ISO files to a path local `iso_contents` folder.
1. Create a `config.yml` file.
1. Run `build.sh` script with extra arguments `-o`, `-v`, and `-n`.
1. It will build a container image and map into the volume the `config.yml` and the `blob` directory.
1. It will start the virtual machine build process.

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
