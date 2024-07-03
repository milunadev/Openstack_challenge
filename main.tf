module "public_infra" {
  source = "./modules/public_infra"
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

