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
  }

}

# module "puppet-client" {
#   source = "./modules/puppet-client"
#   providers = {
#     openstack = openstack
#   }
# }

