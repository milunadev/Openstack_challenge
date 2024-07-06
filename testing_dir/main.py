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
    print(tf_vars)  # Agrega esto para verificar las variables
    return tf_vars


vars = load_tf_vars()


@pytest.fixture
def plan(): 
    tf = tftest.TerraformTest(tfdir='..')
    tf.setup()
    plan = tf.plan(output=True, tf_vars=vars)
    return plan

def test_variables(plan):
    tf_vars = plan.variables
    assert "os_username" in tf_vars, "Missing os_username"
    assert "os_project_name" in tf_vars, "Missing os_project_name"

# def test_outputs(plan):
#     outputs = plan.outputs
#     assert "puppet_agents_ips" in outputs
#     assert "puppet_master_ip" in outputs
#     assert "puppet_db_ip" in outputs

if __name__ == "__main__":
    
    pytest.main()
