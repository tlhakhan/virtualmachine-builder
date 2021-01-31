VM_HOSTNAME=$1
# the vm_username and vm_password is determiend from packer-httpdir/ubuntu/20.04/user-data
#

BASEDIR=$(dirname $BASH_SOURCE)
TEMP_VM=$(mktemp --suffix=.json)

cat << eof > "$TEMP_VM"
{
  "vm_hostname": "${VM_HOSTNAME}",
eof

cat << 'eof' >> "$TEMP_VM"
  "vm_cpus": "8",
  "vm_username": "builder", 
  "vm_password": "Welcome123",
  "vm_memory": "8192",
  "vm_disk_adapter_type": "nvme",
  "vm_disk_size": "132768",
  "vm_guest_os_type": "ubuntu-64",
  "vm_boot_command":"dhcp && chain http://repo/artifactory/packer-httpdir/ubuntu/20.04/20.04.ipxe",
  "vm_hpet": "true",
  "vm_vhv":"false",
  "vm_bootstrap_script":"postinstall-scripts/ubuntu/20.04/bootstrap.sh",
  "esx_build_username": "{{ env `ESX_BUILD_USERNAME` }}",
  "esx_build_password": "{{ env `ESX_BUILD_PASSWORD` }}",
  "esx_build_server": "{{ env `ESX_BUILD_SERVER` }}",
  "esx_build_datastore": "{{ env `ESX_BUILD_DATASTORE` }}",
  "esx_build_network": "{{ env `ESX_BUILD_NETWORK` }}"
}
eof

$BASEDIR/build.sh $TEMP_VM
