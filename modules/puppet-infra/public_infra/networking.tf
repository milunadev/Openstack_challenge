data "openstack_networking_network_v2" "public_network" {
    name = var.public_network_name
}

data "openstack_networking_network_v2" "private_network_1" {
    name = var.private_network_1_name
}

data "openstack_networking_network_v2" "private_network_2" {
    name = var.private_network_2_name
}

data "openstack_networking_subnet_v2" "private_subnet_1" {
    network_id = data.openstack_networking_network_v2.private_network_1.id
}

data "openstack_compute_keypair_v2" "puppet_db_key" {
  name = var.puppet_db_key
}

data "openstack_compute_keypair_v2" "puppet_agent_key" {
  name = var.puppet_agent_key
}

data "openstack_compute_keypair_v2" "puppet_server_key" {
  name = var.puppet_server_key
}

################################################################
#                OPENSTACK PRIVATE PORT
################################################################
resource "openstack_networking_port_v2" "private_interface" {
  name = "${var.public_instance_parameters["instance_name"]}-private-interface"
  network_id = data.openstack_networking_network_v2.private_network_1.id
  admin_state_up = true
  fixed_ip {
    subnet_id = data.openstack_networking_subnet_v2.private_subnet_1.id
  }

  security_group_ids = [
    openstack_networking_secgroup_v2.public_instance_sg.id
  ]

  lifecycle {
    ignore_changes = [all_fixed_ips, all_tags, network_id]
  }
}


################################################################


resource "openstack_networking_secgroup_v2" "public_instance_sg" {
  name = "${var.public_instance_parameters["instance_name"]}-sg"
  description = "Security group for public instance"
}


resource "openstack_networking_secgroup_rule_v2" "allow_all_tcp" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  remote_ip_prefix = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.public_instance_sg.id
}

resource "openstack_networking_secgroup_rule_v2" "allow_all_icmp" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "icmp"
  remote_ip_prefix = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.public_instance_sg.id
}