module "public_infra" {
  source = "./modules/public_infra"
  public_instance_parameters = {
    instance_name = "ubuntu-22-04"
    flavor_name   = "m1.tiny"
    key_pair = "PuppetKey"
  }
  public_network_name = "PUBLIC"
  providers = {
    openstack = openstack
  }
}

module "puppet-client" {
  source = "./modules/puppet-client"
  providers = {
    openstack = openstack
  }
}

