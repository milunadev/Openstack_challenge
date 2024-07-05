output "puppet_server_ip" {
  value = openstack_compute_instance_v2.puppet_server.access_ip_v4
}