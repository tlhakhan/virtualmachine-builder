# README
- A placeholder directory for config files used by the `builder` binary.  

# README

## Example config file
```yaml
---
build:
  server: vs-2  # ESX host
  user: builder # ESX user with admin permissions
  password: Secret123 # ESX user's password
  network: VM Network # virtual network to create the VM on
  datastore: nvme1 # the datastore to create the VM on

vm:
  user: sysuser # the VM user
  password: Welcome123 # the VM password

blob:
  dir: installer_blobs # the folder path of the vendor files
```
