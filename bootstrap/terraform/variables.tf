# --- Proxmox Auth ---
variable "proxmox_api_url" {}
variable "proxmox_api_token_id" { sensitive = true }
variable "proxmox_api_token_secret" { sensitive = true }
variable "proxmox_tls_insecure" { default = true }

# --- Host Access (Snippet용) ---
variable "pve_host_address" {}
variable "pve_ssh_user" {}
variable "pve_ssh_private_key_path" {}

# --- Common Config ---
variable "target_node" { default = "pve" }
variable "template_name" { default = "ubuntu-2404-template" }
variable "vm_ssh_public_key" {}

# --- Network ---
variable "network_bridge" {
  description = "Proxmox 네트워크 브리지 인터페이스 (예: vmbr0, vmbr1)"
  type        = string
  default     = "vmbr0"
}

# --- Ansible ---
variable "ansible_user" {
  default = "ubuntu"
}

variable "ansible_ssh_key_path" {
  description = "로컬에서 Ansible 실행 시 사용할 Private Key 경로"
  default     = "~/.ssh/id_rsa"
}

# --- storage ---
variable "storage_pool" { default = "local-lvm" }
variable "snippet_storage_pool" { default = "local" }

# --- Node Definition (Map) ---
variable "k3s_nodes" {
  description = "생성할 K3s 노드 목록"
  type = map(object({
    vmid      = number
    cores     = number
    memory    = number
    disk_size = string
    ip        = optional(string)
    gw        = optional(string)
  }))
}

variable "vm_password" {
  type = string
  sensitive = true
  default = null
}