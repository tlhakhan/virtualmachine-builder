# README
| Folders | Description |
|--- | --- |
autoinstall | This folder holds the files needed by preseed or kickstart process of OS installations.
playbooks| This is the ansible playbooks that packer will run as a post provision step.  These are ansible local playbooks.
templates| This holds a very generic packer template to build any type of VMs on an ESXi host.
var-files| This holds the var-file contents that will be shared to the packer template.

