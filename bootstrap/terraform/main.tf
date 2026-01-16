module "ops_cluster" {
  # GitHub Public Module 참조
  source = "git::https://github.com/h001-lab/OpenCSP-modules.git//terraform/proxmox/vm?ref=main"

  for_each = var.k3s_nodes

  # 변수 매핑
  vm_name   = each.key
  vm_id     = each.value.vmid
  cores     = each.value.cores
  memory    = each.value.memory
  disk_size = each.value.disk_size

  # IP/GW (없으면 null -> DHCP)
  vm_ip = each.value.ip
  vm_gw = each.value.gw

  # 스토리지 설정
  storage_pool         = var.storage_pool
  snippet_storage_pool = var.snippet_storage_pool

  # 공통 설정
  pve_host_address         = var.pve_host_address
  pve_ssh_user             = var.pve_ssh_user
  pve_ssh_private_key_path = var.pve_ssh_private_key_path
  target_node              = var.target_node
  template_name            = var.template_name
  vm_ssh_public_key        = var.vm_ssh_public_key

  # 네트워크 브리지 전달
  vm_network_bridge = var.network_bridge
  vm_password = var.vm_password
}

# 템플릿 파일을 사용하여 Inventory 생성
resource "local_file" "ansible_inventory" {
  filename = "../ansible/inventory.ini"

  content = templatefile("${path.module}/templates/inventory.ini.tpl", {
    # 템플릿에 넘겨줄 변수들
    nodes    = module.ops_cluster
    user     = var.ansible_user
    key_file = var.ansible_ssh_key_path
  })
}
