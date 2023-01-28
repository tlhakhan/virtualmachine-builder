#!ipxe

#
# Ubuntu Installer
#

#
# The $seed_url is used by cloud-init's nocloud-net provider to find the user-data and meta-data files. The trailing slash is important, the cloud-init process sticks 'meta-data' or 'user-data' right after, without prepending a forward slash to the file name.
set seed_url http://{{.HTTPAddress}}/templates/

#
# The $vmlinuz_url and $initrd_url, the files can be found on the iso contents
set vmlinuz_url http://{{.HTTPAddress}}/files/iso_contents/casper/vmlinuz
set initrd_url http://{{.HTTPAddress}}/files/iso_contents/casper/initrd

#
# The $iso_url points to the live-server iso file
set iso_url http://{{.HTTPAddress}}/files/ubuntu-22.04.1-live-server-amd64.iso

kernel ${vmlinuz_url} autoinstall url=${iso_url} net.ifnames=0 biosdevname=0 ip=::::{{ index .PackerVars "vm_name" }}::dhcp ds=nocloud-net;s=${seed_url}
initrd ${initrd_url}
boot

# Notes on what ip= kernel boot parameter means
# https://www.kernel.org/doc/Documentation/filesystems/nfs/nfsroot.txt
# The purpose of ip= in this script is to configure the hostname of the initial ubuntu installer environment, so that doesn't use the default ubuntu-server hostname.
# If you leave the default ubuntu-server hostname, it can cause confusion at the DHCP level if you do many concurrent/parallel builds.
