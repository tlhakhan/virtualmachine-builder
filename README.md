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

### 🚀 Example output
- Building `-o ubuntu` `-v 20.04` virtual machine.
- Virtual machine name is `-n dev-2`.

```
➜  packer-esxi git:(main) ./build.sh -o ubuntu -v 20.04 -n dev-2
2021/03/04 23:33:10 packer version: Packer v1.7.0
2021/03/04 23:33:10 openssl version: OpenSSL 1.1.1f  31 Mar 2020
2021/03/04 23:33:10 http server: 192.168.200.69:39471
2021/03/04 23:33:10 packer output: vmware-iso: output will be in this color.
2021/03/04 23:33:10 packer output:
2021/03/04 23:33:11 packer output: ==> vmware-iso: Retrieving ISO
2021/03/04 23:33:11 packer output: ==> vmware-iso: Trying https://github.com/tlhakhan/ipxe-iso/releases/download/v1.0/ipxe.iso
2021/03/04 23:33:11 packer output: ==> vmware-iso: Trying https://github.com/tlhakhan/ipxe-iso/releases/download/v1.0/ipxe.iso?checksum=sha256%3Aaed2f5c2a15ebf31a4a2782943bb0cabf59c4f0ccc8c9277822573d7bd6e5adb
    vmware-iso: ipxe.iso 846.00 KiB / 846.00 KiB [==========================================================================================================================================================================================================================================================] 100.00% 0s
2021/03/04 23:33:12 packer output: ==> vmware-iso: https://github.com/tlhakhan/ipxe-iso/releases/download/v1.0/ipxe.iso?checksum=sha256%3Aaed2f5c2a15ebf31a4a2782943bb0cabf59c4f0ccc8c9277822573d7bd6e5adb => /build/packer_cache/59b7f09469af5cdd75c87f6ce5f76a5f8b35b3c9.iso
2021/03/04 23:33:12 packer output: ==> vmware-iso: Configuring output and export directories...
2021/03/04 23:33:12 packer output: ==> vmware-iso: Remote cache was verified skipping remote upload...
2021/03/04 23:33:12 packer output: ==> vmware-iso: Creating required virtual machine disks
2021/03/04 23:33:12 packer output: ==> vmware-iso: Building and writing VMX file
2021/03/04 23:33:12 packer output: ==> vmware-iso: Registering remote VM...
2021/03/04 23:33:13 packer output: ==> vmware-iso: Starting virtual machine...
2021/03/04 23:33:14 packer output: ==> vmware-iso: Connecting to VNC over websocket...
2021/03/04 23:33:14 packer output: ==> vmware-iso: Waiting 10s for boot...
2021/03/04 23:33:24 packer output: ==> vmware-iso: Typing the boot command over VNC...
2021/03/04 23:33:39 packer output: ==> vmware-iso: Waiting for SSH to become available...
2021/03/04 23:33:42 http server: serving request for /installer/ipxe.sh
2021/03/04 23:34:34 http server: serving request for /installer/meta-data
2021/03/04 23:34:34 http server: serving request for /installer/user-data
2021/03/04 23:34:34 http server: serving request for /installer/vendor-data
2021/03/04 23:39:04 packer output: ==> vmware-iso: Connected to SSH!
2021/03/04 23:39:04 packer output: ==> vmware-iso: Gracefully halting virtual machine...
2021/03/04 23:39:11 packer output:     vmware-iso: Waiting for VMware to clean up after itself...
2021/03/04 23:39:16 packer output: ==> vmware-iso: Deleting unnecessary VMware files...
2021/03/04 23:39:16 packer output:     vmware-iso: Deleting: /vmfs/volumes/nvme2/dev-2/vmware.log
2021/03/04 23:39:16 packer output: ==> vmware-iso: Cleaning VMX prior to finishing up...
2021/03/04 23:39:16 packer output:     vmware-iso: Detaching ISO from CD-ROM device sata0:0...
2021/03/04 23:39:16 packer output:     vmware-iso: Disabling VNC server...
2021/03/04 23:39:17 packer output: ==> vmware-iso: Skipping export of virtual machine...
2021/03/04 23:39:17 packer output: ==> vmware-iso: Keeping virtual machine registered with ESX host (keep_registered = true)
2021/03/04 23:39:17 packer output: Build 'vmware-iso' finished after 6 minutes 7 seconds.
2021/03/04 23:39:17 packer output:
2021/03/04 23:39:17 packer output: ==> Wait completed after 6 minutes 7 seconds
2021/03/04 23:39:17 packer output:
2021/03/04 23:39:17 packer output: ==> Builds finished. The artifacts of successful builds are:
2021/03/04 23:39:17 packer output: --> vmware-iso: VM files in directory: /vmfs/volumes/nvme2/dev-2
```

### 🥅 TODOs
- [ ] Use Makefile for Go binary build.
- [ ] Handle `*.iso` mount and unmount without helper scripts.
- [ ] Can this be a Caddy plugin?

## 👏 Appendix
description | link 
--- | ---
iPXE CD used in the virtual machine build process | <https://github.com/tlhakhan/ipxe-iso>
