import tftest
import unittest

class TestPuppetInfra(unittest.TestCase):

    #Create a TerraformTest instance
    @classmethod
    def setUpClass(cls):
        cls.tf = tftest.TerraformTest(../main.tf)
    
    def test_init(self):
        """Test the init function"""
        init = self.tf.init()
        print(f"INIT RESPONSE: {init}")
        self.assertEqual(init['retcode'],0)
    

    
if __name__ == '__main__':
    unittest.main()
