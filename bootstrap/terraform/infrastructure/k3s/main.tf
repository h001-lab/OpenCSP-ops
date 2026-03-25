module "ops_cluster" {
  source = "git::https://github.com/h001-lab/OpenCSP-modules.git//terraform/proxmox/vm?ref=v0.1.0"

  for_each = var.all_vms

  # VM-specific settings
  vm_name   = each.key
  vm_id     = each.value.vmid
  cores     = each.value.cores
  memory    = each.value.memory
  disk_size = each.value.disk_size

  vm_ip = each.value.ip
  vm_gw = each.value.gw

  vm_password = var.vm_password

  storage_pool         = var.storage_pool
  snippet_storage_pool = var.snippet_storage_pool

  # Proxmox connection settings
  pve_host_address         = var.pve_host_address
  pve_ssh_user             = var.pve_ssh_user
  pve_ssh_private_key_path = var.pve_ssh_private_key_path
  target_node              = var.target_node
  template_name            = var.template_name
  vm_ssh_public_key        = var.vm_ssh_public_key

  vm_network_bridge = var.network_bridge
}


resource "local_file" "ansible_inventory" {
  filename = "../../../ansible/inventory/k3s.ini"

  content = templatefile("${path.module}/../../templates/inventory.ini.tpl", {
    nodes    = module.ops_cluster
    user     = var.ansible_user
    key_file = var.ansible_ssh_key_path
  })
}
