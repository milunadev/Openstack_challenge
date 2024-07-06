output "ubuntu_id" {
  value = data.openstack_images_image_v2.ubuntu_22_04.id
}

output "public_network_id" {
  value = data.openstack_networking_network_v2.public_network.id
}

output "public_instance_ip" {
  value = openstack_compute_instance_v2.public_instance.access_ip_v4
}

output "private_interface_ip" {
  value = openstack_networking_port_v2.private_interface.fixed_ip
}

output "private_instance_ip" {
  value = local.private_interface_ip
}