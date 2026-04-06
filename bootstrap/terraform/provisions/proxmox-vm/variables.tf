# Provider
variable "proxmox_api_url" {}
variable "proxmox_api_token_id" { sensitive = true }
variable "proxmox_api_token_secret" { sensitive = true }
variable "proxmox_tls_insecure" { default = true }

# API
variable "vm_name" {}
variable "vm_id" { type = number }
variable "cores" { default = 1 }
variable "memory" { default = 2048 }
variable "disk_size" { default = "50G" }
variable "vm_ip" { default = null }
variable "vm_gw" { default = null }
variable "vm_network_bridge" { default = "vmbr0" }
variable "target_node" { default = "pve" }
variable "template_name" { default = "ubuntu-2404-template" }
variable "storage_pool" { default = "local-lvm" }
variable "snippet_storage_pool" { default = "local" }

# K3S Secret
variable "vm_ssh_public_key" {
  default = null
}
variable "vm_password" {
  sensitive = true
  default   = null
}
variable "pve_host_address" {}
variable "pve_ssh_user" { default = "root" }
variable "pve_ssh_private_key_path" {}