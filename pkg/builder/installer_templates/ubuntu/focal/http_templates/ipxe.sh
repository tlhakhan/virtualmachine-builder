#!ipxe

#
# Ubuntu Installer

#
# The $seed_url is used by cloud-init's nocloud-net provider to find the user-data and meta-data files. The trailing slash is important, the cloud-init process sticks 'meta-data' or 'user-data' right after, without prepending a forward slash to the file name.
set seed_url http://{{.HTTPAddr}}/installer/

#
# The $vmlinuz_url and $initrd_url, the files can be found on the iso contents
set vmlinuz_url http://{{.HTTPAddr}}/blob/iso_contents/casper/vmlinuz
set initrd_url http://{{.HTTPAddr}}/blob/iso_contents/casper/initrd

#
# The $iso_url points to the live-server iso file
set iso_url http://{{.HTTPAddr}}/blob/ubuntu-20.04.3-live-server-amd64.iso

kernel ${vmlinuz_url} autoinstall url=${iso_url} net.ifnames=0 biosdevname=0 ip=::::{{.VirtualMachineName}}::dhcp ds=nocloud-net;s=${seed_url}
initrd ${initrd_url}
boot
