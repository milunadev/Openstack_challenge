resource "openstack_networking_secgroup_v2" "puppet-client-sg" {
  name        = "puppet-client-sg"
  description = "puppet-client-sg"
}