[test_vms]
%{ for name, vm in nodes ~}
${vm.vm_ip} ansible_user=${user} ansible_ssh_private_key_file=${key_file} node_name=${name}
%{ endfor ~}
