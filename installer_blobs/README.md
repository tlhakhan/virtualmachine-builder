# README
This folder is used to store installer blob files of operating systems.
Before building any virtual machine, it is **necessary** to setup this folder with the required vendor files.

file | description
---|---
`get_files.yml` | A helper ansible playbook to download all the needed ISO files.
`mount_iso_folders.yml` | A helper ansible playbook that will mount the ISO files to directories.
