# README
- A placeholder directory for config files used by the `builder` binary.  

## Examples
- Use config files for multiple ESXi hosts.
- Use config files for a single ESXi host, but different datastore or network placement for the VM.

# Example config file
```yaml
---
build:
  server: vsphere-1  # ESX host
  user: builder # ESX user with admin permissions
  password: password # ESX user's password
  network: VM Network # virtual network to create the VM on
  datastore: nvme1 # the datastore to create the VM on  

vm:
  user: guest # the VM user
  password: password # the VM password                   

blob:
  dir: blob # the folder path of the vendor files
```
