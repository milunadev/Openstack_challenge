output "ubuntu_id" {
  value = data.openstack_images_image_v2.ubunttu_22_04.id
}

output "public_network_id" {
  value = data.openstack_networking_network_v2.public_network.id
}