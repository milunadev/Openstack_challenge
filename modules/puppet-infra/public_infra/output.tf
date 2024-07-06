
output "public_instance_private_ip" {
  value = openstack_networking_port_v2.private_interface.fixed_ip
}

output "public_instance_ip" {
  value = openstack_compute_instance_v2.public_instance.access_ip_v4
}