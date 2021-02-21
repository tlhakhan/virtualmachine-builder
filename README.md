# README
This repo helps build virtual machines using packer on ESXi hosts.

file | description
--- | ---
`build.sh` | A helper script used to build virtual machines.
`templates` | The folder that contains packer templates and its dependent files.
`mount_iso_folders.sh` | A helper script to mount ISO files onto a path local `iso` directory.
`unmount_iso_folders.sh` | A helper script to unmount ISO files from path local `iso` directory.
`get_packer.sh` | A helper script to install the latest Packer.


## Getting started
Run the `setup_env.sh` script to create the `.env` file.  This file's content is eventually consumed by packer. The script will ask for credentials and virtual machine placement on the ESXi host. 

prompt | description
--- | ---
ESX Build Server | The ESXi host on which to build virtual machines.
ESX Build Datastore | The datastore name on which to create virtual machine folders.
ESX Build Network | The ESXi port group on which to place the vmnic of the virtual machine.
ESX Build Username | An ESXi user that can build virtual machines on the ESXi host.
ESX Build Password | The password for the given ESX Build Username.
VM Guest Username | The username to SSH into the built virtual machine.
VM Guest Password | The password to SSH into the built virtual machine.

Example `setup_env.sh` output:
```
root@dev-1:~/hub/packer-esxi# ./setup_env.sh
ESX Build Server: vs-200
ESX Build Datastore: nvme1
ESX Build Network: VM Network
ESX Build Username: builder
ESX Build Password:
VM Guest Username: sysuser
VM Guest Password:
Creating .env file
```

## Building a virtual machine
Use the `build.sh` script to create a virtual machine.  The `build.sh` script expects two arguments; the path to the packer template file and the hostname of the new virtual machine.  The templates are located in the `templates` folder.
``` 
root@dev-1:~/hub/packer-esxi# ./build.sh
Usage: ./build.sh [ vm template file ] [ vm name ]
```

In the below example, a vSphere 6.7u3 virtual machine is created; named vss-61.
Example `build.sh` output:
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

# Appendix
document | link
--- | ---
Get ESXi 7.0b Free | <https://my.vmware.com/en/web/vmware/evalcenter?p=free-esxi7>
Get ESXi 6.7u3 Free | <https://my.vmware.com/en/web/vmware/evalcenter?p=free-esxi6>
Installing Packer | <https://learn.hashicorp.com/tutorials/packer/getting-started-install>
Packer vmware-iso builder | <https://www.packer.io/docs/builders/vmware/iso>
Packer shell provisioner | <https://www.packer.io/docs/provisioners/shell>
