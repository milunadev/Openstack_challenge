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

