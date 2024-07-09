data "openstack_images_image_v2" "ubuntu_22_04" {  
    name = var.instance_image_name
}

resource "openstack_blockstorage_volume_v3" "boot_volume" {
  name        = "${var.public_instance_parameters["instance_name"]}-boot-volume"
  size        = var.public_instance_parameters["volume_size"]
  image_id    = data.openstack_images_image_v2.ubuntu_22_04.id
  volume_type = "__DEFAULT__" 

  lifecycle {
    ignore_changes = [image_id, metadata, id]
  }
}

resource "openstack_compute_instance_v2" "public_instance" {
  name = var.public_instance_parameters["instance_name"]
  flavor_name = var.public_instance_parameters["flavor_name"]
  key_pair = var.public_instance_parameters["key_pair"]

  security_groups = [ openstack_networking_secgroup_v2.public_instance_sg.name ]

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

  user_data = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install -y ansible
    echo "${var.puppet_agent_key}" >> /home/ubuntu/puppet-agent-key.pem
    echo "${var.puppet_server_key}" >> /home/ubuntu/puppet-server-key.pem
    echo "${var.puppet_db_key}" >> /home/ubuntu/puppet-db-key.pem
    chown ubuntu:ubuntu /home/ubuntu/puppet-db-key.pem
    chown ubuntu:ubuntu /home/ubuntu/puppet-server-key.pem
    chown ubuntu:ubuntu /home/ubuntu/puppet-agent-key.pem
    chmod 600 /home/ubuntu/puppet-db-key.pem
    chmod 600 /home/ubuntu/puppet-server-key.pem
    chmod 600 /home/ubuntu/puppet-agent-key.pem
  EOT

  lifecycle {
    ignore_changes = [
      access_ip_v4,
      network,
      image_id,
      block_device[0].volume_size,
    ]
  }
}


resource "null_resource" "reboot_public_instance" {
  provisioner "local-exec" {
    command = <<-EOT
      sleep 35
      openstack server reboot ${openstack_compute_instance_v2.public_instance.id}
      sleep 45
    EOT
  }

  depends_on = [openstack_compute_instance_v2.public_instance]
}