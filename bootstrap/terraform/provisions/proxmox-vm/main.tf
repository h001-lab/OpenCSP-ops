terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc6"
    }
  }
}

provider "proxmox" {
  pm_api_url          = var.proxmox_api_url
  pm_api_token_id     = var.proxmox_api_token_id
  pm_api_token_secret = var.proxmox_api_token_secret
  pm_tls_insecure     = var.proxmox_tls_insecure
}

module "vm" {
  source = "git::https://github.com/h001-lab/OpenCSP-modules.git//terraform/proxmox/vm?ref=main"

  vm_name                  = var.vm_name
  vm_id                    = var.vm_id
  cores                    = var.cores
  memory                   = var.memory
  disk_size                = var.disk_size
  vm_ip                    = var.vm_ip
  vm_gw                    = var.vm_gw
  vm_network_bridge        = var.vm_network_bridge
  target_node              = var.target_node
  template_name            = var.template_name
  storage_pool             = var.storage_pool
  snippet_storage_pool     = var.snippet_storage_pool
  vm_ssh_public_key        = var.vm_ssh_public_key
  opencsp_ansible_public_key = var.opencsp_ansible_public_key
  vm_password              = var.vm_password
  pve_host_address         = var.pve_host_address
  pve_ssh_user             = var.pve_ssh_user
  pve_ssh_private_key_path = var.pve_ssh_private_key_path
}