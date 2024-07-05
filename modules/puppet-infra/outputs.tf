output "puppet_server_ip" {
  value = openstack_compute_instance_v2.puppet_server.access_ip_v4
}




output "puppet_public_key" {
  value = tls_private_key.puppet_key.public_key_openssh
}