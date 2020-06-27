#
# CentOS Kickstart Template
#
# Template parameters
#

# System authorization information
auth --enableshadow --passalgo=sha512

# Use network installation area
install
url --url http://repo.home.local/artifactory/centos/7/os/x86_64

# Use text installer
text

# Run the Setup Agent on first boot
firstboot --enabled

# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'

# System language
lang en_US.UTF-8

# Network information
network --bootproto=dhcp --device=eth0 --noipv6 --onboot=yes

# EPEL repo
repo --name="epel" --baseurl=http://repo.home.local/artifactory/centos/7/x86_64

# Root password
rootpw --plaintext root

# System timezone
timezone America/New_York

# System bootloader configuration
bootloader --append="net.ifnames=0 biosdevname=0" --location=mbr --timeout=3 --boot-drive=sda

# Partition clearing information
clearpart --initlabel --linux --drives=sda
zerombr

# sda - minimum 48 GB (rootfs, boot)
part /boot --fstype=xfs --size=1024 --ondisk=sda
part /boot/efi --fstype=efi --size=1024 --ondisk=sda
part pv.01 --fstype=lvmpv --size=1 --grow --ondisk=sda

# create lvm
volgroup vg_root pv.01

logvol swap --vgname=vg_root --fstype=swap --size=4096 --name=lv_swap
logvol / --vgname=vg_root --fstype=xfs --size=4096 --grow --name=lv_root

# SELinux & Firewall
firewall --disabled
selinux --disabled

%packages
@^minimal
@core
chrony
kexec-tools
ansible
# remove defaults
-NetworkManager*
-aic94xx-firmware
-alsa-*
-btrfs-progs*
-dhcp*
-dracut-network
-biosdevname
-iprutils
-ivtv*firmware
-iwl*firmware
-libertas*firmware
-plymouth*
-postfix*
%end

%post

# setup the ssh folder
mkdir -m 0600 /root/.ssh

# add packer's public key to authorized keys 
cat << 'eof' > /root/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+B6xVQx5giGb7uJ+lvdWZEGJgIufq23wr/xGMin4f0+3LB3qDIt536kknG2j35V7BKqpPqF87IrAwtdNC91XKrDuJJ2UafEoeQnDjz8VFdD/SWrkvbiE7UfkVwjgJrpDcgGrcAe5K2Q2ZD4y6v/Ij2CdTaNN0vv0te6VwpJwvt1c0gyNNNGZuc/FLcGPoNnCTXldf2o0rF9LhyJA6lIUFPL7cE6lVgt1k727CHxpYNGaNSOAHMg4N1x47pHw46tRsGVYdrVLjp0g5DQPzUcGaE3eBqC5Hs3kYixbdpvP9Yi6rZZlFJe7EniPnpBsDyEbhnGYmyNW8Brucm61SzM8d
eof
chmod 600 /root/.ssh/authorized_keys

# allow root login with key
echo "PermitRootLogin without-password" >> /etc/ssh/sshd_config

%end

%addon com_redhat_kdump --disable

%end
reboot
