import os
import tftest
import pytest

def load_tf_vars():
    tf_vars = {
        'os_username': os.getenv('TF_VAR_os_username'),
        'os_project_name': os.getenv('TF_VAR_os_project_name'),
        'os_password': os.getenv('TF_VAR_os_password'),
        'os_auth_url': os.getenv('TF_VAR_os_auth_url'),
        'os_region_name': os.getenv('TF_VAR_os_region_name'),
        'os_user_domain_name': os.getenv('TF_VAR_os_user_domain_name'),
        'os_project_domain_id': os.getenv('TF_VAR_os_project_domain_id')
    }
    print(f"Loaded TF Vars: {tf_vars}")  # Imprimir variables para depuración
    return tf_vars

vars = load_tf_vars()  # Llamar explícitamente a la función y almacenar las variables

@pytest.fixture
def plan():
    tf = tftest.TerraformTest(tfdir='.')  # Asegúrate de que esta ruta sea correcta
    tf.setup()
    plan = tf.plan(output=True, tf_vars=vars)
    return plan

def test_variables(plan):
    tf_vars = plan.variables
    print(f"Terraform Variables: {tf_vars}")
    assert "os_username" in tf_vars, "Missing os_username"
    assert "os_project_name" in tf_vars, "Missing os_project_name"

def test_outputs(plan):
    outputs = plan.outputs
    print(f"Terraform Outputs: {outputs}")
    assert "puppet_agents_ips" in outputs
    assert "puppet_server_ip" in outputs
    assert "puppet_db_ip" in outputs

def test_resources_exist(plan):
    resources = plan.root_module.resources
    resource_types = [resource["type"] for resource in resources.values()]

    expected_resources = [
        "openstack_compute_instance_v2",
        "openstack_blockstorage_volume_v3",
        "openstack_networking_secgroup_v2",
        "local_file",
        "null_resource"
    ]

    for expected_resource in expected_resources:
        assert expected_resource in resource_types, f"Missing resource: {expected_resource}"

def test_puppet_agent_configuration(plan):
    puppet_agents = [resource for resource in plan.root_module.resources.values() if resource["type"] == "openstack_compute_instance_v2" and "puppet-agent" in resource["name"]]

    for agent in puppet_agents:
        assert agent["values"]["flavor_name"] == "m1.small", "Puppet Agent flavor mismatch"
        assert agent["values"]["key_pair"] == "puppet-agent-key", "Puppet Agent key pair mismatch"
        assert agent["values"]["security_groups"] == ["puppet-agent-sg"], "Puppet Agent security group mismatch"

def test_no_puppet_agents():
    tf_no_agents = tftest.TerraformTest(tfdir='.')
    tf_no_agents.setup()
    no_agents_plan = tf_no_agents.plan(output=True, tf_vars={**vars, "puppet_agent_parameters": {"count": 0}})
    
    puppet_agents = [resource for resource in no_agents_plan.root_module.resources.values() if resource["type"] == "openstack_compute_instance_v2" and "puppet-agent" in resource["name"]]
    assert len(puppet_agents) == 0, "There should be no Puppet Agents"

if __name__ == "__main__":
    print("Running tests...")
    pytest.main()
