output "vm_name" {
  value = module.vm.vm_name
}

output "vm_ip" {
  description = "VM IP (QEMU Agent가 실행된 후 확인 가능)"
  value       = module.vm.vm_ip
}

output "vm_ssh_public_key" {
  description = "VM에 등록된 SSH public key (외부 주입 또는 자동 생성)"
  value       = module.vm.ssh_public_key
}

output "vm_ssh_private_key" {
  description = "VM 접속용 SSH private key (자동 생성한 경우에만 유효)"
  value       = module.vm.ssh_private_key
  sensitive   = true
}