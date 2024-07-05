module "public_infra" {
  source = "./modules/public_infra"
  public_instance_parameters = {
    instance_name = "public-terra"
    flavor_name   = "m1.tiny"
    key_pair = "PuppetKey"
  }
  public_network_name = "PUBLIC"
  providers = {
    openstack = openstack
  }
  private_puppet_key = module.puppet-infra.private_key_puppet
  depends_on = [ module.puppet-infra ]
}

module "puppet-infra" {
  source = "./modules/puppet-infra"
  providers = {
    openstack = openstack
  }

  project_name = "challenger18"


  public_network_name = "PUBLIC"
  private_network_1_name = "PRIVATE-1"
  private_network_2_name = "PRIVATE-2"


  puppet_server_parameters = {
    flavor_name   = "m1.tiny"
    volume_size   = 10
    key_pair = "PuppetKey"
  }

  puppet_agent_parameters = {
    count = 2
    flavor_name   = "m1.tiny"
    volume_size   = 10
    key_pair = "PuppetKey"
  }

}

# module "puppet-client" {
#   source = "./modules/puppet-client"
#   providers = {
#     openstack = openstack
#   }
# }

