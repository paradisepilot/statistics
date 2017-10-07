
import tensorflow as tf

def firstGraph():

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    x = tf.Variable(3,name="x")
    y = tf.Variable(4,name="y")
    f = x * x * y + y + 2

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    myInitializer = tf.global_variables_initializer()
    with tf.Session() as mySession:
            myInitializer.run()
            result = f.eval()
            print('result')
            print( result )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

