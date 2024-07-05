import os
import tftest
import unittest

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

class TestPuppetInfra(unittest.TestCase):

    #Create a TerraformTest instance
    @classmethod
    def setUpClass(cls):
        cls.tf = tftest.TerraformTest(../main.tf)
        cls.vars = load_tf_vars()
    def test_init(self):
        """Test the init function"""
        init = self.tf.init()
        print(f"INIT RESPONSE: {init}")
        self.assertEqual(init['retcode'],0)
    
    def test_plan(self):
        """Test the terraform plan command with environment variables"""
        self.tf.init()
        plan = self.tf.plan(vars=self.vars)
        if plan['retcode'] != 0:
            print(f"terraform plan failed with retcode {plan['retcode']}")
            print(f"stdout: {plan['stdout']}")
            print(f"stderr: {plan['stderr']}")
        self.assertEqual(plan['retcode'], 0)
    

    
if __name__ == '__main__':
    unittest.main()
