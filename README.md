# README
This repo helps build virtual machines using packer on ESXi hosts.
- [x] Build on a simple network with a basic DHCP server, no need for additional configuration. 
- [x] Doesn't use TFTP server for netbooting.
- [x] Doesn't use a separate HTTP server.
- [x] Build a working container with all required dependencies. Allows for concurrent packer builds.

**Pre-requisites**
- vSphere ESXi host with SSH enabled.

**Supported VM Build Automation**
operating system | version | machine specs
| --- | --- | ---|
debian | 10.7 | 8 vCPU, 8 GiB vRAM, 100 GiB NVMe vDisk
ubuntu | 20.04 | 8 vCPU, 8 GiB vRAM, 100 GiB NVMe vDisk
vsphere | 6.7u3 | 8 vCPU, 32 GiB vRAM, 100 GiB NVMe vDisk
vsphere | 7.0b | 8 vCPU, 32 GiB vRAM, 100 GiB NVMe vDisk

## Getting started
1. Get the ISO files or vendor files.  Each `<os>/<version>` folder in `templates` has a README document for additional reference.
1. Run `mount_iso_folders.sh` to mount ISO files to a path local `iso` folder.
1. Run one of the two methods below.

### Container method
1. Run `builder.sh` script.
1. It will build a container image with its run-time dependencies called `packer-esxi`.
u. It will create a named volume `packer_env` and mount it to `/packer_env` in a container.
1. It will start the `packer-esxi` container.  Any additional arguments given to `builder.sh` is passed to the container's entrypoint.  This can be used to override default vars in `build.yml` playbook by using `-e` extra vars flags.

### Non-container method
1. Install the run-time package dependencies listed in `packages` file.
1. Run `ansible-playbook build.yml`.  A local `packer_env` folder is created to store the packer environment variables, it is gitignored by default.  The default vars in `build.yml` can be overridden by using `-e` extra vars flags.

## File list
file | description
--- | ---
`ansible.cfg` | A ansible default configuration overrides.
`builder.sh` | A helper script to start packer-esxi container run-time.
`build.yml` | An ansible playbook to build virtual machines.
`templates` | The folder with packer templates and its dependent files.
`mount_iso_folders.sh` | A helper script to mount ISO files onto a path local `iso` directory.
`unmount_iso_folders.sh` | A helper script to unmount ISO files from path local `iso` directory.
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
iPXE ISO CD | <https://github.com/tlhakhan/ipxe-iso>
