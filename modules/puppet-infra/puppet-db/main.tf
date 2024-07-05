resource "openstack_blockstorage_volume_v3" "boot_volume_db" {
  name        = "${var.project_name}-db-boot-volume"
  size        = var.puppet_db_parameters["volume_size"]
  image_id    = data.openstack_images_image_v2.puppet_instance_image.id
  volume_type = "__DEFAULT__" 
}

resource "openstack_compute_instance_v2" "puppet_db" { 
  name = "${var.project_name}-puppet-server"
  flavor_name = var.puppet_db_parameters["flavor_name"]
  key_pair = var.puppet_db_parameters["key_pair"]
  security_groups = [ openstack_networking_secgroup_v2.puppet-db-sg.name ]


  network {
    name = var.private_network_1_name
  }

  block_device {
    uuid = openstack_blockstorage_volume_v3.boot_volume_db.id
    source_type = "volume"
    boot_index = 0
    destination_type = "volume"
    delete_on_termination = true
  }
  depends_on = [ openstack_blockstorage_volume_v3.boot_volume_db ]
}


################################################################
#                    PUPPET SERVER SECURITY GROUP
################################################################

resource "openstack_networking_secgroup_v2" "puppet-db-sg" {
  name = "puppet-db-sg"
  description = "Security group for Puppet Database"
}


resource "openstack_networking_secgroup_rule_v2" "allow_puppet_db_5432" {
  description = "Allow traffic to Puppet Database from local, PostgreSQL"
  protocol = "tcp"
  port_range_min = 5432
  port_range_max = 5432
  remote_ip_prefix = data.openstack_networking_subnet_v2.private_subnet_1.cidr
  security_group_id = openstack_networking_secgroup_v2.puppet-db-sg.id
  ethertype = "IPv4"
  direction = "ingress"
}

resource "openstack_networking_secgroup_rule_v2" "allow_icmp_local" {
  description = "Allow SSH traffic to puppet DB from local"
  protocol = "icmp"
  remote_ip_prefix = data.openstack_networking_subnet_v2.private_subnet_1.cidr
  security_group_id = openstack_networking_secgroup_v2.puppet-db-sg.id
  ethertype = "IPv4"
  direction = "ingress"
}

resource "openstack_networking_secgroup_rule_v2" "allow_ssh_local" {
  description = "Allow SSH traffic to puppet DB from local"
  protocol = "tcp"
  port_range_min = 22
  port_range_max = 22
  remote_ip_prefix = data.openstack_networking_subnet_v2.private_subnet_1.cidr
  security_group_id = openstack_networking_secgroup_v2.puppet-db-sg.id
  ethertype = "IPv4"
  direction = "ingress"
}