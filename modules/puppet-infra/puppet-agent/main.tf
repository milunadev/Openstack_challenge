resource "openstack_blockstorage_volume_v3" "boot_volume_agents" {
  count = var.puppet_agent_parameters["count"]  
  name        = "${var.project_name}-agent-boot-volume-${count.index}"
  size        = var.puppet_agent_parameters["volume_size"]
  image_id    = data.openstack_images_image_v2.puppet_instance_image.id
  volume_type = "__DEFAULT__" 
}

resource "openstack_compute_instance_v2" "puppet_agents" {
  count = var.puppet_agent_parameters["count"]  
  name = "${var.project_name}-puppet-agent-${count.index}"
  flavor_name = var.puppet_agent_parameters["flavor_name"]
  key_pair = openstack_compute_keypair_v2.puppet_agent_key.name

  security_groups = [ openstack_networking_secgroup_v2.puppet-agent-sg.name ]

  network {
    name = var.private_network_1_name
  }

  block_device {
    uuid = openstack_blockstorage_volume_v3.boot_volume_agents[count.index].id
    source_type = "volume"
    boot_index = 0
    destination_type = "volume"
    delete_on_termination = true
  }
  depends_on = [ openstack_blockstorage_volume_v3.boot_volume_agents ]
}


################################################################
#                    PUPPET SERVER SECURITY GROUP
################################################################

resource "openstack_networking_secgroup_v2" "puppet-agent-sg" {
  name = "puppet-agent-sg"
  description = "Security group for Puppet Agent"
}


resource "openstack_networking_secgroup_rule_v2" "allow_puppet_agent_8140" {
  description = "Allow Puppet Agent port 8140"
  protocol = "tcp"
  port_range_min = 8140
  port_range_max = 8140
  remote_ip_prefix = data.openstack_networking_subnet_v2.private_subnet_1.cidr
  security_group_id = openstack_networking_secgroup_v2.puppet-agent-sg.id
  ethertype = "IPv4"
  direction = "ingress"
}

resource "openstack_networking_secgroup_rule_v2" "allow_icmp_local" {
  description = "Allow SSH traffic to puppet agent from local"
  protocol = "icmp"
  remote_ip_prefix = data.openstack_networking_subnet_v2.private_subnet_1.cidr
  security_group_id = openstack_networking_secgroup_v2.puppet-agent-sg.id
  ethertype = "IPv4"
  direction = "ingress"
}

resource "openstack_networking_secgroup_rule_v2" "allow_ssh_local" {
  description = "Allow SSH traffic to puppet agent from local"
  protocol = "tcp"
  port_range_min = 22
  port_range_max = 22
  remote_ip_prefix = data.openstack_networking_subnet_v2.private_subnet_1.cidr
  security_group_id = openstack_networking_secgroup_v2.puppet-agent-sg.id
  ethertype = "IPv4"
  direction = "ingress"
}



resource "tls_private_key" "agent_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "openstack_compute_keypair_v2" "puppet_agent_key" {
  name = "puppet-agent-key"
  public_key = tls_private_key.agent_key.public_key_openssh

  depends_on = [ tls_private_key.agent_key ]
}

resource "local_file" "agent_key_pem" {
  content = tls_private_key.agent_key.private_key_pem
  filename = "${path.module}/key/puppet-agent-key.pem"
}