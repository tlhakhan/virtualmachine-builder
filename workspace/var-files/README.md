# var-files definitions
The key values are self explanatory, they will be used by the packer templates as [user variables](https://packer.io/docs/templates/user-variables.html).

key | value
--- | ---
`vm_hostname` | Name of the virtual machine.
`vm_username` | The name of the user that packer will SSH as, after automated OS installation.
`vm_cpus` | The count of vCPUs given to vm.  ESXi free has a limit of 8 vCPUs.
`vm_memory` | The amount of vRAM in megabytes given to the vm.
`vm_disk_size` | The vm will be given one virtual disk with size in megabytes.
`vm_disk_adapter_type` | The vm will be given an adapter type of choice.  The choices can be: `nvme`, `scsi`, `sata`, `ide`.
`vm_guest_os_type` | The vm will be created with this VMX attribute. A few choices are `centos-64`, `centos7-64`, `centos8-64`, `ubuntu-64` and etc.  This can be determined by the examining the VMX file after change in OS selection dropdown in vSphere UI.
`vm_boot_command` | The iPXE shell command that will launch/chain the appropriate iPXE script.  Check out the `packer/autoinstall` folder for `.ipxe` scripts.
`esx_server` | The ESXi host where the vm will be created upon.
`esx_datastore` | The name of the datastore on the ESXi host where the vm's vmdk will be placed upon.
`esx_network` | The name of the network on the ESXi host where the vm's vmnic will be placed upon.
`ansible_playbook_file` | This is the ansible-playbook file that packer will run in the provisioner step.  The playbooks names are referenced relative from the `packer/playbooks` directory.

# example var-file
```json
{
  "vm_hostname": "centos8-00",
  "vm_username": "root",
  "vm_cpus": "4",
  "vm_memory": "4096",
  "vm_disk_adapter_type": "nvme",
  "vm_disk_size": "32768",
  "vm_guest_os_type": "centos8-64",
  "vm_boot_command":"chain http://repo.home.local/artifactory/files/centos8/centos8.ipxe",
  "esx_server": "vs-200",
  "esx_datastore": "nvme2",
  "esx_network": "VM Network",
  "ansible_playbook_file":"centos8.yml"
}
```
