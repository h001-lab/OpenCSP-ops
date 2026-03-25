output "vms" {
  value = {
    for name, vm in module.test-vms : name => {
      vm_name = vm.vm_name
      vm_ip   = vm.vm_ip
    }
  }
}