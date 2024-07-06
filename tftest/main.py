import os
import tftest
import pytest

def load_tf_vars():
    return {
        'os_username': os.getenv('TF_VAR_os_username'),
        'os_project_name': os.getenv('TF_VAR_os_project_name'),
        'os_password': os.getenv('TF_VAR_os_password'),
        'os_auth_url': os.getenv('TF_VAR_os_auth_url'),
        'os_region_name': os.getenv('TF_VAR_os_region_name'),
        'os_user_domain_name': os.getenv('TF_VAR_os_user_domain_name'),
        'os_project_domain_id': os.getenv('TF_VAR_os_project_domain_id')
    }

vars = load_tf_vars()

@pytest.fixture
def plan(directory='../', module_name='puppet-infra'):
    tf = tftest.TerraformTest(module_name, directory)
    tf.setup()
    plan = tf.plan(output=True,tf_vars = vars)
    return plan
