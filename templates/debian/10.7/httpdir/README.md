# README
This folder contains files to automate installation of Debian 10.7.

file | description
--- | ---
`10.7.ipxe` | The iPXE script to launch installation.
`preseed.cfg` | The Debian preseed configuration for automated OS installation.
`initrd.gz` | Required debian-installer file for netboot.
`linux` | Required debian-installer file for netboot.
`vendor_files` | List of required files that need to be downloaded.

## Appendix
- The debian-installer files for Debian 10.7/buster is located at <https://deb.debian.org/debian/dists/buster/main/installer-amd64/current/images/netboot/debian-installer/amd64/>.
- Example `preseed.cfg` file for Debian 10.7/buster is located at <https://www.debian.org/releases/buster/example-preseed.txt>.
