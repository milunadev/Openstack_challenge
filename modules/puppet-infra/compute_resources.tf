resource "tls_private_key" "puppet_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "openstack_compute_keypair_v2" "puppet_keypair" {
  name = "puppet-keypair-nova"
  #public_key = tls_private_key.puppet_key.public_key_openssh
}

data "openstack_images_image_v2" "puppet_instance_image" {
  name = var.instance_image_name
  most_recent = true
}