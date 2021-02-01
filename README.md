# README
This repo helps build virtual machines using packer on ESXi hosts.  This repo is used in conjuction with <http://github.com/tlhakhan/packer-httpdir>.

file | description
--- | ---
`setup_env.sh` | Prompts admin for input to create a `.env` file.  This needs to be run before building an virtual machine.
`build.sh` | A helper script used to build virtual machines.
`get_packer.sh` | A helper script to install the latest Packer on an Ubuntu control machine.


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
