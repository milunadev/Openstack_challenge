output "puppet_agents_ips" {
  value = module.puppet_agents.puppet_agents_ips
}

output "puppet_server_ip" {
  value = module.puppet_server.puppet_server_ip
}

output "puppet_db_ip" {  
  value = module.puppet_db.puppet_db_ip
}

output "public_instance_ip" {
  value = module.public_instance.public_instance_ip
}

output "public_instance_private_ip" {
  value = module.public_instance.public_instance_private_ip
}
