packer {
  required_plugins {
    vmware = {
      source  = "github.com/hashicorp/vmware"
      version = "~> 1"
    }
  }
}

variable "vm_datastore" {
  type = string
}

#
# Virtual machine variables
#
variable "vm_name" {
  type = string
}

variable "vm_cpus" {
  type    = string
  default = "4"
}

variable "vm_memory" {
  type        = string
  default     = "4096"
  description = "Memory size in MiB"
}

variable "vm_disk_size" {
  type        = number
  default     = 20480
  description = "Disk size in MiB"
}

variable "vm_guest_os_type" {
  type    = string
  default = "debian12-64"
}

variable "vm_ipxe_script_url" {
  type    = string
  default = "https://tlhakhan.github.io/virtualbox-builder/debian/bookworm/boot.ipxe"
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

source "vmware-iso" "virtual_machine" {
  boot_command     = ["<wait>", "dhcp && chain ${var.vm_ipxe_script_url}<enter>"]
  vm_name          = var.vm_name
  cpus             = var.vm_cpus
  memory           = var.vm_memory
  disk_size        = var.vm_disk_size
  guest_os_type    = var.vm_guest_os_type
  version          = "21" # see https://kb.vmware.com/s/article/1003746
  iso_checksum     = "cdd2909cc09d8fc6378706a33e184db2945b04df87b7fa245b417fbfdb235f2e"
  iso_url          = "https://github.com/tlhakhan/ipxe-iso/releases/download/v1.2/ipxe.iso"
  keep_registered  = true
  output_directory = "${var.vm_datastore}/${var.vm_name}"
  skip_compaction  = true
  skip_export      = true
  ssh_username     = "packer"
  ssh_password     = "packer"
  ssh_timeout      = "25m"
  shutdown_command = "echo packer | sudo -S poweroff"
  headless         = true
  snapshot_name    = "clean"
  vmx_data = {
    "ulm.disableMitigations" = "true" # see https://ipxe.org/err/1c25e0
  }
  vmx_data_post = {
    "ethernet0.connectionType" = "bridged"
  }
}

build {
  sources = ["source.vmware-iso.virtual_machine"]
  provisioner "shell" {
    inline = [
      "echo '${var.ssh_public_key}' > ~/.ssh/authorized_keys",
      "echo packer | sudo -S bash -c \"echo '${var.ssh_ca_public_key}' > /etc/ssh/trusted_ssh_ca.pub\"",
      "echo packer | sudo -S hostnamectl hostname ${var.vm_name}"
    ]
  }
}