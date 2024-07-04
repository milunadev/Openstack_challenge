data "openstack_images_image_v2" "ubuntu_22_04" {  
    name = "Ubuntu 22.04 LTS"
    most_recent = true
}

resource "openstack_blockstorage_volume_v3" "boot_volume" {
  name        = "${var.public_instance_parameters["instance_name"]}-boot-volume"
  size        = 10
  image_id    = data.openstack_images_image_v2.ubuntu_22_04.id
  volume_type = "__DEFAULT__" 
}


resource "openstack_compute_instance_v2" "public_instance" {
  name = var.public_instance_parameters["instance_name"]
  image_id = data.openstack_images_image_v2.ubuntu_22_04.id
  flavor_name = var.public_instance_parameters["flavor_name"]
  key_pair = var.public_instance_parameters["key_pair"]

  security_groups = [ "permit-all" ]

  network {
    name = var.public_network_name
  }
  network {
    port = openstack_networking_port_v2.private_interface.id
  }

  block_device {
    uuid = openstack_blockstorage_volume_v3.boot_volume.id
    source_type = "volume"
    boot_index = 0
    destination_type = "volume"
    delete_on_termination = true
  }
}


# resource "openstack_compute_instance_v2" "public_instance" {
#   name = var.public_instance_parameters["instance_name"]
#   image_id = data.openstack_images_image_v2.ubuntu_22_04.id
#   flavor_name = var.public_instance_parameters["flavor_name"]
#   key_pair = var.public_instance_parameters["key_pair"]

#   security_groups = [ "permit-all" ]

#   network {
#     name = data.openstack_networking_network_v2.public_network.name
#   }

#   lifecycle {
#     ignore_changes = [ user_data ]
#   }
# }

# resource "openstack_blockstorage_volume_v3" "public_instance_volume" {
#   name = "${var.public_instance_parameters["instance_name"]}-volume"
#   size = 10
# }

# resource "openstack_compute_volume_attach_v2" "public_instance_volume_attach" {
#   instance_id = openstack_compute_instance_v2.public_instance.id
#   volume_id = openstack_blockstorage_volume_v3.public_instance_volume.id
# }