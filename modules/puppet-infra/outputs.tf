output "puppet_agents_ips" {
  value = module.puppet_agents.puppet_agents_ips
}

output "puppet_server_ip" {
  value = module.puppet_server.puppet_server_ip
}

output "puppet_db_ip" {  
  value = module.puppet_db.puppet_db_ip
}

# output "puppet_server_ip" {
#   value = openstack_compute_instance_v2.puppet_server.access_ip_v4
# }




# output "private_key_puppet" {
#   sensitive = true
#   value = tls_private_key.puppet_key.private_key_pem
# }