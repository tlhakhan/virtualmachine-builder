#!ipxe
#
# Debian Installer
#
set preseed_url http://{{.HTTPAddress}}/templates/preseed.cfg 
set linux_url http://deb.debian.org/debian/dists/bullseye/main/installer-amd64/current/images/netboot/debian-installer/amd64/linux
set initrd_url http://deb.debian.org/debian/dists/bullseye/main/installer-amd64/current/images/netboot/debian-installer/amd64/initrd.gz

kernel ${linux_url} auto=true priority=critical interface=auto preseed/url=${preseed_url} DEBIAN_FRONTEND=text net.ifnames=0
initrd ${initrd_url}
boot
