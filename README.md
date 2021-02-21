# README
This repo helps build virtual machines using packer on ESXi hosts.
[x] Requires only a simple DHCP server, no need for additional configuration. 
[x] Doesn't use TFTP server for netbooting.
[x] Doesn't use a separate HTTP server.
[x] Build a working container with all required dependencies.

file | description
--- | ---
`build.yml` | An executable ansible-playbook to build virtual machines.
`templates` | The folder that contains packer templates and its dependent files.
`mount_iso_folders.sh` | A helper script to mount ISO files onto a path local `iso` directory.
`unmount_iso_folders.sh` | A helper script to unmount ISO files from path local `iso` directory.
`docker_run.sh` | A helper script to start packer-esxi container run-time.
`Dockerfile` | A Dockerfile to build a container image of the run-time environment.
`packages` | A list of packages needed in a Debian/Ubuntu run-time environment.

# Appendix
document | link
--- | ---
Get ESXi 7.0b Free | <https://my.vmware.com/en/web/vmware/evalcenter?p=free-esxi7>
Get ESXi 6.7u3 Free | <https://my.vmware.com/en/web/vmware/evalcenter?p=free-esxi6>
Installing Packer | <https://learn.hashicorp.com/tutorials/packer/getting-started-install>
Packer vmware-iso builder | <https://www.packer.io/docs/builders/vmware/iso>
Packer shell provisioner | <https://www.packer.io/docs/provisioners/shell>
