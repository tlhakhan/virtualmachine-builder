packer {
  required_plugins {
    vmware = {
      source  = "github.com/hashicorp/vmware"
      version = "~> 1"
    }
  }
}

#
# ESX server variables
#
variable "esx_server" {
  type = string
}

variable "esx_username" {
  type = string
}

variable "esx_password" {
  type      = string
  sensitive = true
}

variable "esx_datastore" {
  type    = string
  default = "datastore1"
}

#
# Virtual machine variables
#
variable "vm_name" {
  type = string
}

variable "vm_cpus" {
  type    = string
  default = "2"
}

variable "vm_memory" {
  type        = string
  default     = "1024"
  description = "Memory size in MiB"
}

variable "vm_disk_size" {
  type        = number
  default     = 10240
  description = "Disk size in MiB"
}

variable "vm_disk_additional_size" {
  type        = list(number)
  default     = []
  description = "An array of additional disks with disk size in MiB"
}

variable "vm_network" {
  type    = string
  default = "VM Network"
}

variable "vm_guest_os_type" {
  type    = string
  default = "debian12-64"
}

variable "vm_ipxe_script_url" {
  type    = string
  default = "https://tlhakhan.github.io/vmware-builder/debian/bookworm/boot.ipxe"
}

variable "ssh_public_key" {
  type        = string
  default     = ""
  description = "SSH public key to add to packer user's authorized_keys file"
}

variable "ssh_ca_public_key" {
  type        = string
  default     = ""
  description = "SSH CA public key to add as a trusted CA key for sshd_config"
}

locals {
  vmx_data_additional_disks = merge(values({ for index, value in var.vm_disk_additional_size : index => {
    "nvme0:${index + 1}.fileName" = "disk-${index + 1}.vmdk",
    "nvme0:${index + 1}.present"  = "true"
  } })...)
}

source "vmware-iso" "virtual_machine" {
  boot_command              = ["<wait>", "dhcp && chain ${var.vm_ipxe_script_url}<enter>"]
  vm_name                   = var.vm_name
  cpus                      = var.vm_cpus
  memory                    = var.vm_memory
  disk_size                 = var.vm_disk_size
  disk_additional_size      = var.vm_disk_additional_size
  guest_os_type             = var.vm_guest_os_type
  network_name              = var.vm_network
  format                    = "vmx"
  disk_type_id              = "thin"
  disk_adapter_type         = "nvme"
  network_adapter_type      = "vmxnet3"
  version                   = "20"   # More info: https://kb.vmware.com/s/article/1003746
  insecure_connection       = "true" # needed for self-signed certificates by esxi host
  iso_checksum              = "cdd2909cc09d8fc6378706a33e184db2945b04df87b7fa245b417fbfdb235f2e"
  iso_url                   = "https://github.com/tlhakhan/ipxe-iso/releases/download/v1.2/ipxe.iso"
  keep_registered           = "true"
  remote_datastore          = var.esx_datastore
  remote_host               = var.esx_server
  remote_username           = var.esx_username
  remote_password           = var.esx_password
  remote_cache_datastore    = var.esx_datastore
  remote_cache_directory    = "packer_cache/${var.vm_name}"
  remote_port               = "22"
  remote_type               = "esx5"
  skip_compaction           = "true"
  skip_export               = "true"
  skip_validate_credentials = "true"
  ssh_username              = "packer"
  ssh_password              = "packer"
  ssh_timeout               = "25m"
  shutdown_command          = "echo packer| sudo -S poweroff"
  vmx_data = merge({
    "mem.hotadd"                  = "true"
    "numa.autosize"               = "true"
    "numa.autosize.once"          = "false"
    "vcpu.hotadd"                 = "true"
    "vmxnet3.rev.30"              = "false"
    "pciPassthru.use64bitMMIO"    = "true"  # gpu passthru
    "pciPassthru.64bitMMIOSizeGB" = "64"    # gpu passthru
    "pciPassthru.msiEnabled"      = "false" # gpu passthru
    "hypervisor.cpuid.v0"         = "false" # gpu passthru
  }, local.vmx_data_additional_disks)
  vnc_over_websocket = "true"
}

#
# For quick debugging of provisioner scripts
# Run using: packer build -only=null.provisioner_debug ...
#
source "null" "provisioner_debug" {
  ssh_host     = var.vm_name
  ssh_username = "packer"
  ssh_password = "packer"
}

build {
  sources = ["source.vmware-iso.virtual_machine", "sources.null.provisioner_debug"]
  provisioner "shell" {
    inline = [
      "echo '${var.ssh_public_key}' > ~/.ssh/authorized_keys",
      "echo packer | sudo -S bash -c \"echo '${var.ssh_ca_public_key}' > /etc/ssh/trusted_ssh_ca.pub\"",
      "echo packer | sudo -S hostnamectl hostname ${var.vm_name}"
    ]
  }
}
