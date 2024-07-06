[puppet_agents]
%{ for ip in puppet_agents_ips ~}
puppet-agent ansible_host=${ip} ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/puppet-agent-key.pem ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
%{ endfor ~}

[puppet_server]
puppet-server ansible_host=${puppet_server_ip} ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/puppet-server-key.pem ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'

[puppet_db]
puppet-db ansible_host=${puppet_db_ip} ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/puppet-db-key.pem ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
