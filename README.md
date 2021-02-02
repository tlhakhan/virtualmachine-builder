# README
This repo helps build virtual machines using packer on ESXi hosts.  This repo is used in conjuction with <http://github.com/tlhakhan/packer-httpdir>.

file | description
--- | ---
`setup_env.sh` | Prompts user for input to create a `.env` file.  This needs to be run before building an virtual machine.
`build.sh` | A helper script used to build virtual machines.
`get_packer.sh` | A helper script to install the latest Packer.


## Getting started
Run the `setup_env.sh` script to create the `.env` file.  This file's content is eventually consumed by packer. The script will ask for credentials and virtual machine placement on the ESXi host. See below for an example.

```
root@dev-1:~/hub/packer-esxi# ./setup_env.sh
ESX Build Server: vs-200
ESX Build Datastore: nvme1
ESX Build Network: VM Network
ESX Build Username: builder
ESX Build Password:
Creating .env file
```

prompt | description
--- | ---
ESX Build Server | The ESXi host on which to build virtual machines.
ESX Build Datastore | The datastore name on which to create virtual machine folders.
ESX Build Network | The ESXi port group on which to place the vmnic of the virtual machine.
ESX Build Username | An ESXi user that can build virtual machines on the ESXi host.
ESX Build Password | The password for the given ESX Build Username.

## Building a virtual machine
Use the `build.sh` script to start creating a virtual machine.

### Usage of build.sh script
The `build.sh` script expects two arguments; the path to the template file and the name of the new virtual machine.  The templates are located in the `templates` folder.
``` 
root@dev-1:~/hub/packer-esxi# ./build.sh
Usage: ./build.sh [ vm template file ] [ vm name ]
```

### Example build.sh output
In the below example, a vSphere 6.7u3 virtual machine is created; named vss-61.

```
root@dev-1:~/hub/packer-esxi# ./build.sh templates/vsphere/6.7u4/vm.json vss-61
Sourced .env file
Validating virtual machine configuration for templates/vsphere/6.7u4/vm.json.
Performing virtual machine build for templates/vsphere/6.7u4/vm.json.
vmware-iso: output will be in this color.

==> vmware-iso: Retrieving ISO
==> vmware-iso: Trying http://repo/artifactory/packer-httpdir/ipxe/ipxe.iso
==> vmware-iso: Trying http://repo/artifactory/packer-httpdir/ipxe/ipxe.iso?checksum=sha256%3A660133790495615079577e521890e9cbb746a38f5497edce304fb64244bd19f6
==> vmware-iso: http://repo/artifactory/packer-httpdir/ipxe/ipxe.iso?checksum=sha256%3A660133790495615079577e521890e9cbb746a38f5497edce304fb64244bd19f6 => /root/hub/packer-esxi/packer_cache/d2b53bccf516fa98993103d34af3b73ff3f79775.iso
==> vmware-iso: Configuring output and export directories...
==> vmware-iso: Uploading ISO to remote machine...
    vmware-iso: d2b53bccf516fa98993103d34af3b73ff3f79775.iso 840.00 KiB / 840.00 KiB [=] 100.00% 0s
==> vmware-iso: Creating required virtual machine disks
==> vmware-iso: Building and writing VMX file
==> vmware-iso: Registering remote VM...
==> vmware-iso: Starting virtual machine...
==> vmware-iso: Connecting to VNC over websocket...
==> vmware-iso: Waiting 10s for boot...
==> vmware-iso: Typing the boot command over VNC...
==> vmware-iso: Waiting for SSH to become available...
==> vmware-iso: Connected to SSH!
==> vmware-iso: Provisioning with shell script: postinstall-scripts/vsphere/6.7u3/bootstrap.sh
==> vmware-iso: Gracefully halting virtual machine...
    vmware-iso: Waiting for VMware to clean up after itself...
==> vmware-iso: Deleting unnecessary VMware files...
    vmware-iso: Deleting: /vmfs/volumes/nvme1/vss-61/vmware.log
==> vmware-iso: Compacting all attached virtual disks...
    vmware-iso: Compacting virtual disk 1
==> vmware-iso: Cleaning VMX prior to finishing up...
    vmware-iso: Detaching ISO from CD-ROM device sata0:0...
    vmware-iso: Disabling VNC server...
==> vmware-iso: Skipping export of virtual machine...
==> vmware-iso: Keeping virtual machine registered with ESX host (keep_registered = true)
Build 'vmware-iso' finished after 7 minutes 25 seconds.

==> Wait completed after 7 minutes 25 seconds

==> Builds finished. The artifacts of successful builds are:
--> vmware-iso: VM files in directory: /vmfs/volumes/nvme1/vss-61
```
