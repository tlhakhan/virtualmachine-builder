# README
This repo helps build virtual machines using packer on ESXi hosts.

file | description
--- | ---
`setup_env.sh` | Prompts admin for input to create a `.env` file.  This needs to be run before building an virtual machine.
`gen_ubuntu_vm.sh` | Builds a simple Ubuntu virtual machine.
`gen_vsphere6_vm.sh` | Builds a simple vSphere 6.7u3 virtual machine.
`gen_vsphere7_vm.sh` | Builds a simple vSphere 7.0b virtual machine.
`get_packer.sh` | A helper script to install the latest Packer on an Ubuntu control machine.
`build.sh` | A generic build script used by the `gen_` scripts; performs the actual validate and build.
