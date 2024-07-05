data "openstack_images_image_v2" "puppet_instance_image" {
  name = var.instance_image_name
  most_recent = true
}

################################################################
#                   PUBLIC NETWORK RESOURCES
################################################################
data "openstack_networking_network_v2" "public_network" {
    name = var.public_network_name
}

data "openstack_networking_subnet_v2" "public_subnet_1" {
    network_id = data.openstack_networking_network_v2.public_network.id
}


################################################################
#                   PRIVATE NETWORK RESOURCES
################################################################
data "openstack_networking_network_v2" "private_network_1" {
    name = var.private_network_1_name
}

data "openstack_networking_network_v2" "private_network_2" {
    name = var.private_network_2_name
}

data "openstack_networking_subnet_v2" "private_subnet_1" {
    network_id = data.openstack_networking_network_v2.private_network_1.id
}