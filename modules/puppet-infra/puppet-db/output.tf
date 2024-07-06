output "puppet_db_ip" {
  value = openstack_compute_instance_v2.puppet_db.access_ip_v4
}

output "puppet_db_key" {
  value = local_file.db_key_pem.content
}