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

}




resource "local_file" "inventory" {
  content = templatefile("./ansible_dir/inventory.tpl", {
    puppet_agents_ips = module.puppet-infra.puppet_agents_ips
    puppet_server_ip = module.puppet-infra.puppet_server_ip
    puppet_db_ip = module.puppet-infra.puppet_db_ip
  })
  filename = "${path.module}/ansible_dir/inventory/hosts.ini"

}

resource "null_resource" "wait_for_public_instance" {
  provisioner "local-exec" {
    command = "sleep 40 && ping -c 8 ${module.puppet-infra.public_instance_ip}"
  }

  depends_on = [module.puppet-infra]
}


resource "null_resource" "upload_ansible_dir" {
  depends_on = [ module.puppet-infra, local_file.inventory, null_resource.wait_for_public_instance ]
  provisioner "local-exec" {
    command = "scp -i ../puppetkey.pem -o StrictHostKeyChecking=no -r ./ansible_dir/* ubuntu@${module.puppet-infra.public_instance_ip}:/home/ubuntu/ansible_dir"
  }
}

resource "null_resource" "provision_puppet_agent" {
  depends_on = [null_resource.upload_ansible_dir]
  provisioner "local-exec" {
    command = <<-EOT
      echo "STARTING"      
      ssh-keyscan -H ${module.puppet-infra.public_instance_ip} >> ~/.ssh/known_hosts
      ssh -i ../puppetkey.pem -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ubuntu@${module.puppet-infra.public_instance_ip} << 'EOF'
        ansible-playbook -i /home/ubuntu/ansible_dir/inventory/hosts.ini /home/ubuntu/ansible_dir/site.yml --extra-vars "puppet_server_ip=${module.puppet-infra.puppet_server_ip} puppet_db_ip=${module.puppet-infra.puppet_db_ip} puppet_server_hostname=${module.puppet-infra.puppet_server_name} puppet_db_hostname=${module.puppet-infra.puppet_db_name}" --tags puppet_agent
      EOF
    EOT
  }
}

resource "null_resource" "provision_puppet_server" {
  depends_on = [null_resource.provision_puppet_agent]

  provisioner "local-exec" {
    command = <<-EOT
      ssh -i ../puppetkey.pem -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ubuntu@${module.puppet-infra.public_instance_ip} << 'EOF'
        ansible-playbook -i /home/ubuntu/ansible_dir/inventory/hosts.ini /home/ubuntu/ansible_dir/site.yml  --extra-vars "puppet_server_ip=${module.puppet-infra.puppet_server_ip} puppet_db_ip=${module.puppet-infra.puppet_db_ip} puppet_server_hostname=${module.puppet-infra.puppet_server_name} puppet_db_hostname=${module.puppet-infra.puppet_db_name}" --tags puppet_server
      EOF
    EOT
  }
}


resource "null_resource" "request_certificate" {
  depends_on = [ null_resource.provision_puppet_server ]

  provisioner "local-exec" {
    command = <<-EOT
      ssh -i ../puppetkey.pem -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ubuntu@${module.puppet-infra.public_instance_ip} << 'EOF'
        ansible-playbook -i /home/ubuntu/ansible_dir/inventory/hosts.ini /home/ubuntu/ansible_dir/playbooks/request_certificate.yml
      EOF
    EOT
  }
}

resource "null_resource" "sign_certificate" {
  depends_on = [ null_resource.request_certificate ]

  provisioner "local-exec" {
    command = <<-EOT
      ssh -i ../puppetkey.pem -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ubuntu@${module.puppet-infra.public_instance_ip} << 'EOF'
        ansible-playbook -i /home/ubuntu/ansible_dir/inventory/hosts.ini /home/ubuntu/ansible_dir/playbooks/sign_certificate.yml
      EOF
    EOT
  }
}