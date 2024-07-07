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
  value = module.public_instance[0].public_instance_ip
}

output "public_instance_private_ip" {
  value = module.public_instance[0].public_instance_private_ip
}

output "puppet_agents_names" {
  value = module.puppet_agents.puppet_agents_names
}

output "puppet_server_name" {
  value = module.puppet_server.puppet_server_name
}

output "puppet_db_name" {
  value = module.puppet_db.puppet_db_name
}