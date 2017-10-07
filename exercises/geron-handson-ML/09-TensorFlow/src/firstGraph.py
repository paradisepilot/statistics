
import tensorflow as tf

def firstGraph():

    print("\nCreating your first graph and running it in a session:")

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

