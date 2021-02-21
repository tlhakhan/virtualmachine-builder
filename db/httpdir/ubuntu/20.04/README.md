# README
This folder contains files to automate installation of Ubuntu 20.04.

file | description
--- | ---
`20.04.ipxe` | The iPXE script to launch OS installation.
`user-data` | Used by cloud-init.  Contains the Ubuntu *autoinstall* yaml config.
`meta-data` | Used by cloud-init.  Empty file, its existence is required for cloud-init to proceed.
`vendor_files` | List of required files for easy download.

# Appendix
`ubuntu-20.04.2-live-server-amd64.iso` | This ISO file can be found at <https://releases.ubuntu.com/20.04/>.
