#!ipxe

#
# RHEL 8.3
#

set vmlinuz_url http://{{.HTTPAddr}}/blob/iso_contents/images/pxeboot/vmlinuz
set initrd_url http://{{.HTTPAddr}}/blob/iso_contents/images/pxeboot/initrd.img
set repo_url http://{{.HTTPAddr}}/blob/iso_contents
set kickstart_url http://{{.HTTPAddr}}/installer/ks.cfg

kernel ${vmlinuz_url} initrd=initrd.img net.ifnames=0 biosdevname=0 inst.repo=${repo_url} inst.ks=${kickstart_url}
initrd ${initrd_url}
boot
