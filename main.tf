module "public_infra" {
  source = "./modules/public_infra"
  public_instance_parameters = {
    instance_name = "public-terra"
    flavor_name   = "m1.tiny"
    key_pair = "PuppetKey"
  }
  public_network_name = "PUBLIC"
  providers = {
    openstack = openstacks
  }
}

module "puppet-client" {
  source = "./modules/puppet-client"
  providers = {
    openstack = openstack
  }
}

