module "puppet-infra" {
  source = "./modules/puppet-infra"
  providers = {
    openstack = openstack
  }

  deploy_public_instance = var.deploy_public_instance
  public_instance_parameters = var.public_instance_parameters

  project_name = var.project_name
  public_network_name = var.public_network_name
  private_network_1_name = var.private_network_1_name
  private_network_2_name = var.private_network_2_name

  instance_image_name = var.instance_image_name
  puppet_server_parameters = var.puppet_server_parameters
  puppet_agent_parameters = var.puppet_agent_parameters
  puppet_db_parameters = var.puppet_db_parameters

  puppet_agent_key = tls_private_key.agent_key.private_key_pem
  depends_on = [ openstack_compute_keypair_v2.puppet_agent_key ]
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
  filename = "${path.module}/keys/puppet-agent-key.pem"
}

resource "local_file" "inventory" {
  content = templatefile("./ansible_dir/inventory.tpl", {
    puppet_agents_ips = module.puppet-infra.puppet_agents_ips
  })
  filename = "${path.module}/ansible_dir/inventory/host.ini"

}

resource "null_resource" "provision_ansible" {
  depends_on = [ module.puppet-infra, local_file.inventory ]
  
  provisioner "local-exec" {
    command = <<EOT
      scp -i ../puppetkey.pem -o StrictHostKeyChecking=no -r ./ansible_dir/* ubuntu@${module.puppet-infra.public_instance_ip}:/home/ubuntu/ansible_dir
      
      ssh -i ../puppetkey.pem -o StrictHostKeyChecking=no ubuntu@${module.puppet-infra.public_instance_ip} << EOF
        ansible-playbook -i /home/ubuntu/ansible_dir/inventory/host.ini /home/ubuntu/ansible_dir/puppet_agent.yml
      EOF
    EOT
  }
}