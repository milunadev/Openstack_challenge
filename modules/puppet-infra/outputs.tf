output "puppet_agents_ips" {
  value = [for agent in module.puppet_agents : agent.network[0].fixed_ip_v4]
}

output "puppet_server_ip" {
  value = module.puppet_server.puppet_server_ip
}

output "puppet_db_ip" {  
  value = module.puppet_db.puppet_db_ip
}

output "public_instance_ip" {
  value = module.public_instance[0].public_instance_ip
}

output "public_instance_private_ip" {
  value = module.public_instance[0].public_instance_private_ip
}

