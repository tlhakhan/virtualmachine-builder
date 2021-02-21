# README
This repo helps build virtual machines using packer on ESXi hosts.
- [x] Requires only a simple DHCP server, no need for additional configuration. 
- [x] Doesn't use TFTP server for netbooting.
- [x] Doesn't use a separate HTTP server.
- [x] Build a working container with all required dependencies.

*Pre-requisites*
- vSphere ESXi host with SSH enabled.

## Getting started
1. Get the ISO files or vendor files.  Each `<os>/<version>` folder in `templates` has a README document for additional reference.
1. Run `mount_iso_folders.sh` to mount ISO files to a path local `iso` folder.

### Container method
1. Run `docker_run.sh`.
  1. It will build a container image with its run-time dependencies called `packer-esxi`.
  1. It will create a named volume `packer_env` and mount it to `/packer_env` in a container.
  1. It will start the `packer-esxi` container.  Any additional arguments given to `docker_run.sh` is passed to the container.  This can be used to override default vars in `build.yml` playbook by using `-e` extra vars flag.

### Non-container method
1. Install the run-time package dependencies listed in `packages` file.
1. Run `ansible-playbook build.yml`.  A local `packer_env` folder is created to store the packer environment variables, it is gitignored by default.

## File List
file | description
--- | ---
`build.yml` | An ansible playbook to build virtual machines.
`templates` | The folder with packer templates and its dependent files.
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
