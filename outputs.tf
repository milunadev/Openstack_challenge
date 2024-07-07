
################################################################
#                   PUBLIC INFRASTRUCTURE OUTPUTS
################################################################

output "public_instance_public_ip" {
  value = module.puppet-infra.public_instance_ip
}

output "public_instance_private_ip" {
  value = module.puppet-infra.public_instance_private_ip
}


################################################################
#                   PUPPET INFRASTRUCTURE OUTPUTS
################################################################
output "puppet_agents_ips" {
  value = module.puppet-infra.puppet_agents_ips
}

output "puppet_server_ip" {
  value = module.puppet-infra.puppet_server_ip
}

output "puppet_db_ip" {
  value = module.puppet-infra.puppet_db_ip
}


output "puppet_agent_name" {
  value = module.puppet-infra.puppet_agent_name
}

output "puppet_server_name" {
  value = module.puppet-infra.puppet_server_name
}


output "puppet_db_name" {
  value = module.puppet-infra.puppet_db_name
}