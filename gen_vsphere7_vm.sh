#!/bin/bash

VM_HOSTNAME=$1

if [[ -z $VM_HOSTNAME ]]
then
  echo "Provide a virtual machine hostname"
  echo "Usage: $0 [ vm hostname ]"
  exit 1
fi

BASEDIR=$(dirname $BASH_SOURCE)
TEMP_VM=$(mktemp --suffix=.json -t "${VM_HOSTNAME}-XXXXXXXXXX")

cat << eof > "$TEMP_VM"
{
  "vm_hostname": "${VM_HOSTNAME}",
eof

# the vm_username and vm_password is determined from packer-httpdir/vsphere/7.0b/ks.cfg
cat << 'eof' >> "$TEMP_VM"
  "vm_cpus": "8",
  "vm_username": "root",
  "vm_password": "Welcome123",
  "vm_memory": "32768",
  "vm_disk_adapter_type": "nvme",
  "vm_disk_size": "132768",
  "vm_guest_os_type": "vmkernel7",
  "vm_boot_command": "dhcp && chain http://repo/artifactory/packer-httpdir/vsphere/7.0b/7.0b.ipxe",
  "vm_vhv": "true",
  "vm_hpet": "true",
  "vm_bootstrap_script": "postinstall-scripts/vsphere/7.0b/bootstrap.sh",
  "esx_build_username": "{{ env `ESX_BUILD_USERNAME` }}",
  "esx_build_password": "{{ env `ESX_BUILD_PASSWORD` }}",
  "esx_build_server": "{{ env `ESX_BUILD_SERVER` }}",
  "esx_build_datastore": "{{ env `ESX_BUILD_DATASTORE` }}",
  "esx_build_network": "{{ env `ESX_BUILD_NETWORK` }}"
}
eof

bash $BASEDIR/build.sh "$TEMP_VM"

