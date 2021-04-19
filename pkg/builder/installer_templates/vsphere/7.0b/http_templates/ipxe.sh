#!ipxe
#
# vSphere 7.0b
#
set esx_boot http://{{.HTTPAddr}}/blob/iso_contents/mboot.c32
set boot_cfg http://{{.HTTPAddr}}/installer/boot.cfg
set ks_cfg http://{{.HTTPAddr}}/installer/ks.cfg
#
#
kernel ${esx_boot} -c ${boot_cfg} BOOTIF=${netX/mac} runweasel ks=${ks_cfg}
boot
