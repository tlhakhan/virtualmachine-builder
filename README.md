# README
A docker-compose project which uses a packer container to build a virtual machine on an ESXi hypervisor.

## var-files
There is a folder called `var-files`, place virtual machine configuration as a json file.
The filename should be name of the virtual machine. This is used by the packer container to identify the `var-file`.

## Walkthrough
Place configuration json in the `var-files` folder, named after the virtual machine.
- Run the `docker-compose run packer [ vm-name ]`.
- If no argument given, it will fail with a help message requesting a virtual machine name.
