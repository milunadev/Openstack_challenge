resource "openstack_blockstorage_volume_v3" "boot_volume_agents" {
  count = var.puppet_agent_parameters["count"]  
  name        = "${var.project_name}-agent-boot-volume-${count.index}"
  size        = var.puppet_agent_parameters["volume_size"]
  image_id    = data.openstack_images_image_v2.puppet_instance_image.id
  volume_type = "__DEFAULT__" 
}

resource "openstack_compute_instance_v2" "puppet_server" {
  count = var.puppet_agent_parameters["count"]  
  name = "${var.project_name}-puppet-agent-${count.index}"
  flavor_name = var.puppet_agent_parameters["flavor_name"]
  key_pair = var.puppet_agent_parameters["key_pair"]

  security_groups = [ openstack_networking_secgroup_v2.puppet-server-sg.name ]

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
