# README This repo helps build virtual machines using packer on ESXi hosts.
- [x] Requires only a simple DHCP server, no need for additional configuration. 
- [x] Doesn't use TFTP server for netbooting.
- [x] Doesn't use a separate HTTP server.
- [x] Build a working container with all required dependencies.

file | description
--- | ---
`build.yml` | An ansible-playbook to build virtual machines.
`templates` | The folder that contains packer templates and its dependent files.
`mount_iso_folders.sh` | A helper script to mount ISO files onto a path local `iso` directory.
`unmount_iso_folders.sh` | A helper script to unmount ISO files from path local `iso` directory.
`docker_run.sh` | A helper script to start packer-esxi container run-time.
`Dockerfile` | A Dockerfile to build a container image of the run-time environment.
`packages` | A list of packages needed in a Debian/Ubuntu run-time environment.

## Pre-requisites
- ESXi host with a SSH access.

## Getting started
1. Get the ISO files or vendor files.  Each `<os>/<version>` folder in `templates` has a README document for additional reference.
1. Run `mount_iso_folders.sh` to mount ISO files to a path local `iso` folder.

### Container method
1. Run `docker_run.sh`.  It will build a container with all the run-time dependencies.  It will create a named volume `packer_env` and mount it to `/packer_env` in the container.  It will then run the ansible-playbook `build.yml`.  Any additional arguments given to `docker_run.sh` is passed to the ansible-playbook process.  This can be used to override vars using `-e` extra vars flag.

### Non-container method
1. Get run-time package dependencies listed in `packages` file.  
1. Run `ansible-playbook build.yml`.  A `packer_env` folder is created to store the packer env vars, it is gitignored by default.

# Appendix
document | link
--- | ---
Get ESXi 7.0b Free | <https://my.vmware.com/en/web/vmware/evalcenter?p=free-esxi7>
Get ESXi 6.7u3 Free | <https://my.vmware.com/en/web/vmware/evalcenter?p=free-esxi6>
Installing Packer | <https://learn.hashicorp.com/tutorials/packer/getting-started-install>
Packer vmware-iso builder | <https://www.packer.io/docs/builders/vmware/iso>
Packer shell provisioner | <https://www.packer.io/docs/provisioners/shell>
