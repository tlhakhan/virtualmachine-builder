//
// ESX server variables
//
variable "esx_datastore" {
  type    = string
  default = "datastore1"
}

variable "esx_network" {
  type    = string
  default = "VM Network"
}

variable "esx_username" {
  type    = string
  default = "builder"
}

variable "esx_password" {
  type      = string
  sensitive = true
}

variable "esx_server" {
  type = string
}

//
// Virtual machine variables
//
variable "vm_name" {
  type = string
}

variable "vm_cpus" {
  type    = string
  default = "2"
}

variable "vm_memory" {
  type    = string
  default = "1024"
}

variable "vm_disk_adapter_type" {
  type    = string
  default = "nvme"
}

variable "vm_disk_size" {
  type    = number
  default = 10240
}

// VM hardware version details found here: https://kb.vmware.com/s/article/1003746
variable "vm_version" {
  type    = string
  default = "20"
}

variable "vm_guest_os_type" {
  type    = string
  default = "debian12-64"
}

variable "vm_ipxe_script" {
  type    = string
  default = "debian/bookworm/ipxe.sh"
}

source "vmware-iso" "virtual_machine" {
  boot_command              = ["<wait>", "dhcp && chain https://tlhakhan.github.io/vmware-builder/${var.vm_ipxe_script}<enter>"]
  cpus                      = var.vm_cpus
  disk_adapter_type         = var.vm_disk_adapter_type
  disk_size                 = var.vm_disk_size
  disk_type_id              = "thin"
  format                    = "vmx"
  guest_os_type             = var.vm_guest_os_type
  insecure_connection       = "true"
  iso_checksum              = "cdd2909cc09d8fc6378706a33e184db2945b04df87b7fa245b417fbfdb235f2e"
  iso_url                   = "https://github.com/tlhakhan/ipxe-iso/releases/download/v1.2/ipxe.iso"
  keep_registered           = "true"
  memory                    = var.vm_memory
  network_adapter_type      = "vmxnet3"
  remote_cache_datastore    = var.esx_datastore
  remote_cache_directory    = "packer_cache/${var.vm_name}"
  remote_datastore          = var.esx_datastore
  remote_host               = var.esx_server
  remote_password           = var.esx_password
  remote_port               = "22"
  remote_type               = "esx5"
  remote_username           = var.esx_username
  shutdown_command          = "echo packer| sudo -S poweroff"
  skip_compaction           = "true"
  skip_export               = "true"
  skip_validate_credentials = "true"
  ssh_username              = "packer"
  ssh_password              = "packer"
  ssh_timeout               = "25m"
  version                   = var.vm_version
  vm_name                   = var.vm_name
  vmx_data = {
    "ethernet0.networkName"       = "${var.esx_network}"
    "mem.hotadd"                  = "true"
    "numa.autosize"               = "true"
    "numa.autosize.once"          = "false"
    "vcpu.hotadd"                 = "true"
    "vmxnet3.rev.30"              = "false"
    "pciPassthru.use64bitMMIO"    = "true"  # gpu passthru
    "pciPassthru.64bitMMIOSizeGB" = "64"    # gpu passthru
    "pciPassthru.msiEnabled"      = "false" # gpu passthru
    "hypervisor.cpuid.v0"         = "false" # gpu passthru
  }
  vnc_over_websocket = "true"
}

build {
  sources = ["source.vmware-iso.virtual_machine"]
  provisioner "shell" {
    inline = ["echo packer | sudo -S hostnamectl hostname ${var.vm_name}"]
  }
}
