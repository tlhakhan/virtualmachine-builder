#!ipxe
#
# Debian 10.7
#
set preseed_url http://{{.HTTPAddr}}/installer/preseed.cfg 
set linux_url http://{{.HTTPAddr}}/blob/linux
set initrd_url http://{{.HTTPAddr}}/blob/initrd.gz
#
kernel ${linux_url} auto=true priority=critical interface=auto preseed/url=${preseed_url} DEBIAN_FRONTEND=text
initrd ${initrd_url}
boot
