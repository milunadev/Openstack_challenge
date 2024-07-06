module "puppet_agents" {
  source = "./puppet-agent"
  project_name = var.project_name
  puppet_agent_parameters = var.puppet_agent_parameters
  public_network_name = var.public_network_name
  private_network_1_name = var.private_network_1_name
  private_network_2_name = var.private_network_2_name
  providers = {
    openstack = openstack
  }
}

module "puppet_server" {
  source = "./puppet-server"
  project_name = var.project_name
  puppet_server_parameters = var.puppet_server_parameters
  public_network_name = var.public_network_name
  private_network_1_name = var.private_network_1_name
  private_network_2_name = var.private_network_2_name
  providers = {
    openstack = openstack
  }
}

module "puppet_db" {
  source = "./puppet-db"
  project_name = var.project_name
  puppet_db_parameters = var.puppet_db_parameters
  public_network_name = var.public_network_name
  private_network_1_name = var.private_network_1_name
  private_network_2_name = var.private_network_2_name
  providers = {
    openstack = openstack
  }
}

module "public_instance" {
  count = var.deploy_public_instance ? 1 : 0
  source = "./public_infra"
  public_network_name = var.public_network_name
  private_network_1_name = var.private_network_1_name
  private_network_2_name = var.private_network_2_name
  instance_image_name = var.instance_image_name
  public_instance_parameters = var.public_instance_parameters

  puppet_agent_key = module.puppet_agents.puppet_agent_key
  puppet_db_key = module.puppet_db.puppet_db_key
  puppet_server_key = module.puppet_server.puppet_server_key

  puppet_db_ip = module.puppet_db.puppet_db_ip
  puppet_agent_ips = module.puppet_agents.puppet_agents_ips
  puppet_server_ip = module.puppet_server.puppet_server_ip
  providers = {
    openstack = openstack
  }

  depends_on = [ module.puppet_agents, module.puppet_db, module.puppet_server ]

}

