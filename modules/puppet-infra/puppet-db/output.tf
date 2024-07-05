output "puppet_db_ip" {
  value = openstack_compute_instance_v2.puppet_db.access_ip_v4
}