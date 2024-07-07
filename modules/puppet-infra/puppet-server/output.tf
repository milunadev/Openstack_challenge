output "puppet_server_ip" {
  value = openstack_compute_instance_v2.puppet_server.access_ip_v4
}

output "puppet_server_key" {
  value = local_file.server_key_pem.content
}

output "puppet_server_name" {
  value = openstack_compute_instance_v2.puppet_server.name
}