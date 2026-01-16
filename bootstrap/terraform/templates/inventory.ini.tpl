[master]
%{ for name, vm in nodes ~}
%{ if !can(regex("worker|agent", name)) ~}
${vm.vm_ip} ansible_user=${user} ansible_ssh_private_key_file=${key_file} node_name=${name}
%{ endif ~}
%{ endfor ~}

[worker]
%{ for name, vm in nodes ~}
%{ if can(regex("worker|agent", name)) ~}
${vm.vm_ip} ansible_user=${user} ansible_ssh_private_key_file=${key_file} node_name=${name}
%{ endif ~}
%{ endfor ~}

[k3s_nodes:children]
master
worker