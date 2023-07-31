#!ipxe
#
# Debian Installer
#
set preseed_url http://{{.HTTPAddress}}/templates/preseed.cfg 
set linux_url http://{{.HTTPAddress}}/files/linux
set initrd_url http://{{.HTTPAddress}}/files/initrd.gz
#
kernel ${linux_url} auto=true priority=critical interface=auto ipv6.disable=1 preseed/url=${preseed_url} DEBIAN_FRONTEND=text net.ifnames=0
initrd ${initrd_url}
boot
