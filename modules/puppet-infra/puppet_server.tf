resource "openstack_blockstorage_volume_v3" "boot_volume_server" {
  name        = "${var.project_name}-server-boot-volume"
  size        = var.puppet_server_parameters["volume_size"]
  image_id    = data.openstack_images_image_v2.puppet_instance_image.id
  volume_type = "__DEFAULT__" 
}

resource "openstack_compute_instance_v2" "puppet_server" {
  name = "${var.project_name}-puppet-server"
  flavor_name = var.puppet_server_parameters["flavor_name"]
  key_pair = var.puppet_server_parameters["key_pair"]

  security_groups = [ openstack_networking_secgroup_v2.puppet-server-sg.name ]

  network {
    name = var.private_network_1_name
  }

  block_device {
    uuid = openstack_blockstorage_volume_v3.boot_volume_server.id
    source_type = "volume"
    boot_index = 0
    destination_type = "volume"
    delete_on_termination = true
  }

  depends_on = [ openstack_compute_keypair_v2.puppet_keypair ]
}
