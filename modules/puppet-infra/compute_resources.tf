resource "openstack_compute_keypair_v2" "puppet_keypair" {
  name = "puppet-keypair"
}

data "openstack_images_image_v2" "puppet_instance_image" {
  name = var.instance_image_name
  most_recent = true
}