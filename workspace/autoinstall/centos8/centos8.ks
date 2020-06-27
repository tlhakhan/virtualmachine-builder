#
# CentOS 8 Kickstart 
#

#version=RHEL8
ignoredisk --only-use=sda
# System bootloader configuration
bootloader --append="console=ttyS0,115200n8 console=tty0 net.ifnames=0 rd.blacklist=nouveau nvme_core.io_timeout=4294967295  crashkernel=auto" --location=mbr --timeout=1 --boot-drive=sda
# Clear the Master Boot Record
zerombr
# Partition clearing information
clearpart --all --initlabel
# Reboot after installation
reboot
# Use text mode install
text
# Keyboard layouts
# old format: keyboard us
# new format:
keyboard --vckeymap=us --xlayouts=''
# System language
lang en_US.UTF-8

# Network information
network  --bootproto=dhcp --device=link --activate

# EPEL repo
repo --name="epel" --baseurl=http://repo.home.local/artifactory/centos/8/Everything/x86_64

# Use network installation
url --url="http://repo.home.local/artifactory/centos/8/BaseOS/x86_64/os/"
# Root password
rootpw --plaintext root
# System authorization information
auth --enableshadow --passalgo=sha512
# SELinux & firewalld configuration
selinux --disabled
firewall --disabled

firstboot --disable
# Do not configure the X Window System
skipx
# System services
services --disabled="kdump" --enabled="sshd,NetworkManager,rngd,chronyd"
# System timezone
timezone America/New_York

# Disk partitioning information
part /boot --fstype=xfs --size=1024 --ondisk=sda
part pv.01 --fstype=lvmpv --size=1 --grow --ondisk=sda

# create lvm
volgroup vg_root pv.01

logvol swap --vgname=vg_root --fstype=swap --size=4096 --name=lv_swap
logvol / --vgname=vg_root --fstype=xfs --size=4096 --grow --name=lv_root


%pre --erroronfail
/usr/sbin/parted -s /dev/sda mklabel gpt
%end

%post --erroronfail

# workaround anaconda requirements
passwd -d root
passwd -l root

mkdir /data

# setup systemd to boot to the right runlevel
echo -n "Setting default runlevel to multiuser text mode"
rm -f /etc/systemd/system/default.target
ln -s /lib/systemd/system/multi-user.target /etc/systemd/system/default.target
echo .

# this is installed by default but we don't need it in virt
echo "Removing linux-firmware package."
yum -C -y --noplugins remove linux-firmware

# Remove firewalld; it is required to be present for install/image building.
echo "Removing firewalld."
yum -C -y --noplugins remove firewalld --setopt="clean_requirements_on_remove=1"

echo -n "Getty fixes"
# although we want console output going to the serial console, we don't
# actually have the opportunity to login there. FIX.
# we don't really need to auto-spawn _any_ gettys.
sed -i '/^#NAutoVTs=.*/ a\
NAutoVTs=0' /etc/systemd/logind.conf

echo -n "Network fixes"
# initscripts don't like this file to be missing.
cat > /etc/sysconfig/network << EOF
NETWORKING=yes
NOZEROCONF=yes
EOF

# For cloud images, 'eth0' _is_ the predictable device name, since
# we don't want to be tied to specific virtual (!) hardware
rm -f /etc/udev/rules.d/70*
ln -s /dev/null /etc/udev/rules.d/80-net-name-slot.rules

# simple eth0 config, again not hard-coded to the build hardware
cat > /etc/sysconfig/network-scripts/ifcfg-eth0 << EOF
DEVICE="eth0"
BOOTPROTO="dhcp"
ONBOOT="yes"
TYPE="Ethernet"
USERCTL="yes"
PEERDNS="yes"
IPV6INIT="no"
EOF

# generic localhost names
cat > /etc/hosts << EOF
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

EOF
echo .

cat <<EOL > /etc/sysconfig/kernel
# UPDATEDEFAULT specifies if new-kernel-pkg should make
# new kernels the default
UPDATEDEFAULT=yes

# DEFAULTKERNEL specifies the default kernel package type
DEFAULTKERNEL=kernel
EOL

# make sure firstboot doesn't start
echo "RUN_FIRSTBOOT=NO" > /etc/sysconfig/firstboot

echo "Cleaning old yum repodata."
yum --noplugins clean all
truncate -c -s 0 /var/log/yum.log

echo "Fixing SELinux contexts."
touch /var/log/cron
touch /var/log/boot.log
mkdir -p /var/cache/yum
/usr/sbin/fixfiles -R -a restore

sed -i -e 's/ rhgb quiet//' /boot/grub/grub.conf

cat > /etc/modprobe.d/blacklist-nouveau.conf << EOL
blacklist nouveau
EOL

# Rerun dracut for the installed kernel (not the running kernel):
KERNEL_VERSION=$(rpm -q kernel --qf '%{V}-%{R}.%{arch}\n')
dracut -f /boot/initramfs-$KERNEL_VERSION.img $KERNEL_VERSION

cat /dev/null > /etc/machine-id

cat >> /etc/chrony.conf << EOF

# NTP Sync Service
server 192.168.200.1 prefer iburst minpoll 4 maxpoll 4
EOF

%end

%packages
@core
NetworkManager
dhcp-client
dracut-config-generic
dracut-norescue
gdisk
grub2
kernel
kexec-tools
rng-tools
rsync
tar
yum-utils
ansible
-aic94xx-firmware
-alsa-firmware
-alsa-lib
-alsa-tools-firmware
-biosdevname
-iprutils
-ivtv-firmware
-iwl100-firmware
-iwl1000-firmware
-iwl105-firmware
-iwl135-firmware
-iwl2000-firmware
-iwl2030-firmware
-iwl3160-firmware
-iwl3945-firmware
-iwl4965-firmware
-iwl5000-firmware
-iwl5150-firmware
-iwl6000-firmware
-iwl6000g2a-firmware
-iwl6000g2b-firmware
-iwl6050-firmware
-iwl7260-firmware
-libertas-sd8686-firmware
-libertas-sd8787-firmware
-libertas-usb8388-firmware
-plymouth

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

%addon com_redhat_kdump --enable --reserve-mb='auto'

%end
