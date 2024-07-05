output "puppet_agents_ips" {
  value = openstack_compute_instance_v2.puppet_agents.*.access_ip_v4
}