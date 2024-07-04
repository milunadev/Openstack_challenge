data "openstack_networking_network_v2" "public_network" {
    name = var.public_network_name
}

data "openstack_networking_network_v2" "private_network_1" {
    name = var.private_network_1_name
}

data "openstack_networking_network_v2" "private_network_2" {
    name = var.private_network_2_name
}

data "openstack_networking_subnet_v2" "private_network_1_subnet" {
    name = var.private_subnet_1
}