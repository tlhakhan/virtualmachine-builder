#!ipxe

#
# NixOS 22.11
#

set vmlinuz_url http://{{.HTTPAddress}}/files/iso_contents/boot/bzImage
set initrd_url http://{{.HTTPAddress}}/files/iso_contents/boot/initrd
set squashfs_url http://{{.HTTPAddress}}/files/iso_contents/nix-store.squashfs
set iso_url http://{{.HTTPAddress}}/files/latest-nixos-minimal-x86_64-linux.iso

kernel ${vmlinuz_url} initrd=initrd.magic nohibernate loglevel=4 boot.shell_on_fail init=nix/store/ydvcwi28lglmjzq5nk4cn2af9ncir3l3-nixos-system-nixos-22.11.1459.8c03897e262/init root=/latest-nixos-minimal-x86_64-linux.iso live.nixos.passwd={{.GuestPassword}}
initrd ${initrd_url}
initrd ${iso_url} /latest-nixos-minimal-x86_64-linux.iso
boot
