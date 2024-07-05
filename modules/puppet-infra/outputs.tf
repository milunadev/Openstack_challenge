output "puppet_server_ip" {
  value = openstack_compute_instance_v2.puppet_server.access_ip_v4
}




output "private_key_puppet" {
  value = tls_private_key.puppet_key.private_key_pem
}