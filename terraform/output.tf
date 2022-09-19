

output "instance_server_public_key_user1" {
  value = openstack_compute_keypair_v2.user1.public_key
}

output "instance_server_private_key_user1" {
  value = openstack_compute_keypair_v2.user1.private_key
}

output "instance_ip_OracleDB" {
  value = openstack_compute_floatingip_associate_v2.OracleDB_floating_ip_association.floating_ip
}

output "instance_ip_gestaut_vm" {
  value = openstack_compute_floatingip_associate_v2.gestaut_vm_floating_ip_association.floating_ip
}

output "instance_ip_elasticsearch_vm" {
  value = openstack_compute_floatingip_associate_v2.elasticsearch_vm_floating_ip_association.floating_ip
}

output "instance_ip_edi_vm" {
  value = openstack_compute_floatingip_associate_v2.edi_vm_floating_ip_association.floating_ip
}

