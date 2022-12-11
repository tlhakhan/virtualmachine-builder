#!ipxe

#
# VMware Photon 4 OS
#

set kickstart_url http://{{.HTTPAddress}}/templates/ks.cfg
set vmlinuz_url http://{{.HTTPAddress}}/files/iso_contents/isolinux/vmlinuz
set initrd_url http://{{.HTTPAddress}}/files/iso_contents/isolinux/initrd.img
set repo_url http://{{.HTTPAddress}}/files/iso_contents/RPMS

kernel ${vmlinuz_url} initrd=initrd.img root=/dev/ram0 ks=${kickstart_url} repo=${repo_url} insecure_installation=1
initrd ${initrd_url}
boot
