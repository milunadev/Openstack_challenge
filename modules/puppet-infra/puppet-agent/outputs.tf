output "puppet_agents_ips" {
  value = openstack_compute_instance_v2.puppet_agents.*.access_ip_v4
}
output "puppet_agent_key" {
  value = local_file.agent_key_pem.content
}