module "puppet-client" {
  source = "./modules/puppet-client"
  providers = {
    openstack = openstack
  }
}
