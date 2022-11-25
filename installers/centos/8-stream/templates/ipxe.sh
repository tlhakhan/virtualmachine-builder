#!ipxe

#
# CentOS 8-Stream
#

set kickstart_url http://{{.HTTPAddress}}/templates/ks.cfg
set vmlinuz_url http://{{.HTTPAddress}}/files/iso_contents/images/pxeboot/vmlinuz
set initrd_url http://{{.HTTPAddress}}/files/iso_contents/images/pxeboot/initrd.img

kernel ${vmlinuz_url} initrd=initrd.img net.ifnames=0 biosdevname=0 inst.ks=${kickstart_url}
initrd ${initrd_url}
boot
