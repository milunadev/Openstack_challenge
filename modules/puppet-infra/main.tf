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