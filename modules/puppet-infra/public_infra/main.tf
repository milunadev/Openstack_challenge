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
    ssh-keyscan -H ${var.puppet_db_ip} >> /home/ubuntu/.ssh/known_hosts
    ssh-keyscan -H ${var.puppet_server_ip} >> /home/ubuntu/.ssh/known_hosts

    for ip in ${join(" ", var.puppet_agent_ips)}; do
      ssh-keyscan -H $ip >> /home/ubuntu/.ssh/known_hosts
    done

    chown ubuntu:ubuntu /home/ubuntu/puppet-db-key.pem
    chown ubuntu:ubuntu /home/ubuntu/puppet-server-key.pem
    chown ubuntu:ubuntu /home/ubuntu/puppet-agent-key.pem
    chmod 600 /home/ubuntu/puppet-db-key.pem
    chmod 600 /home/ubuntu/puppet-server-key.pem
    chmod 600 /home/ubuntu/puppet-agent-key.pem

    reboot
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
      sleep 10
      openstack server stop ${openstack_compute_instance_v2.public_instance.id}
      sleep 45
      openstack server start ${openstack_compute_instance_v2.public_instance.id}
      sleep 45
    EOT
  }

  depends_on = [openstack_compute_instance_v2.public_instance]
}