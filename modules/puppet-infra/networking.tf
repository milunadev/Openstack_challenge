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

locals {
  private_interface_ip = cidrhost(data.openstack_networking_subnet_v2.private_subnet_1.cidr, 10)
}


################################################################
#                OPENSTACK PRIVATE PORT
################################################################
# resource "openstack_networking_port_v2" "private_interface" {
#   name = "${var.public_instance_parameters["instance_name"]}-private-interface"
#   network_id = data.openstack_networking_network_v2.private_network_1.id

#   fixed_ip {
#     subnet_id = data.openstack_networking_subnet_v2.private_subnet_1.id
#   }
# }