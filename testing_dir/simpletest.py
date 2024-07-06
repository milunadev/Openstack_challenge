import tftest

def test_tftest():
    tf = tftest.TerraformTest(tfdir='../')
    tf.setup()
    plan = tf.plan(output=True)
    assert plan

if __name__ == "__main__":
    test_tftest()
