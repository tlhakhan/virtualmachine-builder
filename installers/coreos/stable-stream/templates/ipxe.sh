#!ipxe

#
# CoreOS Stable-Stream
#

set ignition_url http://{{.HTTPAddress}}/templates/ignition.json
set vmlinuz_url http://{{.HTTPAddress}}/files/iso_contents/images/pxeboot/vmlinuz
set initrd_url http://{{.HTTPAddress}}/files/iso_contents/images/pxeboot/initrd.img
set rootfs_url http://{{.HTTPAddress}}/files/iso_contents/images/pxeboot/rootfs.img

kernel ${vmlinuz_url} initrd=initrd.img net.ifnames=0 biosdevname=0 coreos.inst.ignition_url=${ignition_url} coreos.live.rootfs_url=${rootfs_url} coreos.inst.install_dev=/dev/nvme0n1
initrd ${initrd_url}
boot
