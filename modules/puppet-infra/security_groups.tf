################################################################
#                    PUPPET SERVER SECURITY GROUP
################################################################
resource "openstack_networking_secgroup_v2" "puppet-server-sg" {
  name = "puppet-server-sg"
  description = "Security group for Puppet Server"
}

resource "openstack_networking_secgroup_rule_v2" "allow_puppet_server_8140" {
  description = "Allow Puppet Server port 8140"
  port_range_min = 1
  port_range_max = 65535
  protocol = "tcp"
  remote_ip_prefix = data.openstack_networking_subnet_v2.private_subnet_1.cidr
  security_group_id = openstack_networking_secgroup_v2.puppet-server-sg.id
  ethertype = "IPv4"
  direction = "ingress"
}

resource "openstack_networking_secgroup_rule_v2" "allow_ssh_server" {
  description = "Allow SSH from public network"
  port_range_min = 22
  port_range_max = 22
  protocol = "tcp"
  remote_ip_prefix = data.openstack_networking_subnet_v2.public_subnet_1.cidr
  security_group_id = openstack_networking_secgroup_v2.puppet-server-sg.id
  ethertype = "IPv4"
  direction = "ingress"
}


resource "openstack_networking_secgroup_rule_v2" "allow_icmp_server" {
  description = "Allow SSH from public network"
  protocol = "icmp"
  remote_ip_prefix = data.openstack_networking_subnet_v2.public_subnet_1.cidr
  security_group_id = openstack_networking_secgroup_v2.puppet-server-sg.id
  ethertype = "IPv4"
  direction = "ingress"
}

################################################################
#                    PUPPET CLIENT SECURITY GROUP
################################################################
resource "openstack_networking_secgroup_v2" "puppet-client-sg" {
  name = "puppet-client-sg"
  description = "Security group for Puppet Client"
}

resource "openstack_networking_secgroup_rule_v2" "allow_puppet_client_8140" {
  description = "Allow Puppet Server port 8140"
  port_range_min = 8140
  port_range_max = 8140
  protocol = "tcp"
  remote_ip_prefix = data.openstack_networking_subnet_v2.private_subnet_1.cidr
  security_group_id = openstack_networking_secgroup_v2.puppet-client-sg.id
  ethertype = "IPv4"
  direction = "ingress"
}

resource "openstack_networking_secgroup_rule_v2" "allow_ssh_client" {
  description = "Allow SSH from public network"
  port_range_min = 22
  port_range_max = 22
  protocol = "tcp"
  remote_ip_prefix = data.openstack_networking_subnet_v2.public_subnet_1.cidr
  security_group_id = openstack_networking_secgroup_v2.puppet-client-sg.id
  ethertype = "IPv4"
  direction = "ingress"
}


resource "openstack_networking_secgroup_rule_v2" "allow_icmp_client" {
  description = "Allow SSH from public network"
  protocol = "icmp"
  remote_ip_prefix = data.openstack_networking_subnet_v2.public_subnet_1.cidr
  security_group_id = openstack_networking_secgroup_v2.puppet-client-sg.id
  ethertype = "IPv4"
  direction = "ingress"
}


################################################################
#                    PUPPET DB SECURITY GROUP
################################################################
resource "openstack_networking_secgroup_v2" "puppet-db" {
  name = "puppet-db"
  description = "Security group for Puppet DB"
}

resource "openstack_networking_secgroup_rule_v2" "allow_puppet_db_5432" {
  description = "Allow Puppet Server port 8140"
  port_range_min = 5432
  port_range_max = 5432
  protocol = "tcp"
  remote_ip_prefix = data.openstack_networking_subnet_v2.private_subnet_1.cidr
  security_group_id = openstack_networking_secgroup_v2.puppet-db.id
  ethertype = "IPv4"
  direction = "ingress"
}

resource "openstack_networking_secgroup_rule_v2" "allow_ssh_db" {
  description = "Allow SSH from public network"
  port_range_min = 22
  port_range_max = 22
  protocol = "tcp"
  remote_ip_prefix = data.openstack_networking_subnet_v2.public_subnet_1.cidr
  security_group_id = openstack_networking_secgroup_v2.puppet-db.id
  ethertype = "IPv4"
  direction = "ingress"
}


resource "openstack_networking_secgroup_rule_v2" "allow_icmp_db" {
  description = "Allow SSH from public network"
  protocol = "icmp"
  remote_ip_prefix = data.openstack_networking_subnet_v2.public_subnet_1.cidr
  security_group_id = openstack_networking_secgroup_v2.puppet-db.id
  ethertype = "IPv4"
  direction = "ingress"
}
