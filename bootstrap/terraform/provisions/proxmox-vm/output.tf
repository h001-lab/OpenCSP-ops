output "vm_name" {
  value = module.vm.vm_name
}

output "vm_ip" {
  description = "VM IP (QEMU Agent가 실행된 후 확인 가능)"
  value       = module.vm.vm_ip
}