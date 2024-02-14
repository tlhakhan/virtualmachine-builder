packer {
  required_plugins {
    virtualbox = {
      version = "~> 1"
      source  = "github.com/hashicorp/virtualbox"
    }
  }
}

#
# VirtualBox variables
#
variable "vbox_bridge_adapter_name" {
  type        = string
  description = "The name of the host's network adapter to bridge the virtual machine's network adapter to."
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
  default     = "2048"
  description = "Memory size in MiB"
}

variable "vm_disk_directory" {
  type        = string
  description = "The parent directory to store the virtual machine's disk(s)."
  default     = "datastore"
}

variable "vm_disk_size" {
  type        = number
  default     = 20480
  description = "Disk size in MiB"
}

variable "vm_disk_additional_size" {
  type        = list(number)
  default     = []
  description = "An array of additional disks with disk size in MiB"
}

variable "vm_guest_os_type" {
  type    = string
  default = "Debian12_64"
}

variable "vm_ipxe_script_url" {
  type    = string
  default = "https://tlhakhan.github.io/virtualbox-builder/debian/bookworm/boot.ipxe"
}

variable "ssh_public_key" {
  type        = string
  default     = ""
  description = "The SSH public key to add to packer user's authorized_keys file."
}

variable "ssh_ca_public_key" {
  type        = string
  default     = ""
  description = "The SSH CA public key to add as a trusted CA key for sshd_config."
}

source "virtualbox-iso" "main" {
  vm_name                  = var.vm_name
  cpus                     = var.vm_cpus
  memory                   = var.vm_memory
  disk_size                = var.vm_disk_size
  disk_additional_size     = var.vm_disk_additional_size
  guest_os_type            = var.vm_guest_os_type
  iso_checksum             = "cdd2909cc09d8fc6378706a33e184db2945b04df87b7fa245b417fbfdb235f2e"
  iso_url                  = "https://github.com/tlhakhan/ipxe-iso/releases/download/v1.2/ipxe.iso"
  boot_command             = ["<wait>", "dhcp && chain ${var.vm_ipxe_script_url}<enter>"]
  ssh_username             = "packer"
  ssh_password             = "packer"
  ssh_timeout              = "25m"
  hard_drive_nonrotational = true
  keep_registered          = true
  skip_export              = true
  shutdown_command         = "echo packer | sudo -S poweroff"
  output_directory         = "${var.vm_disk_directory}/${uuidv4()}"
  vboxmanage = [
    ["modifyvm", var.vm_name, "--description", "Created: ${timestamp()}"]
  ]
}

build {
  sources = ["source.virtualbox-iso.main"]
  provisioner "shell" {
    inline = [
      "echo '${var.ssh_public_key}' > ~/.ssh/authorized_keys",
      "echo packer | sudo -S bash -c \"echo '${var.ssh_ca_public_key}' > /etc/ssh/trusted_ssh_ca.pub\"",
      "echo packer | sudo -S hostnamectl hostname ${var.vm_name}",
    ]
  }
  post-processor "shell-local" {
    inline = [
      "VBoxManage modifyvm ${var.vm_name} --nic1 bridged",
      "VBoxManage modifyvm ${var.vm_name} --bridgeadapter1 \"${var.vbox_bridge_adapter_name}\"",
    ]
  }
}
