output "ubuntu22_image_id" {
  value = module.public_infra.ubuntu_id
}

output "public_network_id" {
  value = module.public_infra.public_network_id
}

output "private_interface_ip" {
  value = module.public_infra.private_interface_ip
}