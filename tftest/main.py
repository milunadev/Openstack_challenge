import tftest
import unittest

class TestPuppetInfra(unittest.TestCase):

    def setUpClass(cls):
        cls.tf = tftest.TerraformTest(../main.tf)
    
    def test_init(self):
        """Test the init function"""
        init = self.tf.init()
        self.assertEqual(init['retcode'],0)
    
    
    

