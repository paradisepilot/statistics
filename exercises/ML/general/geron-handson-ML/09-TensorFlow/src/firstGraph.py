
import numpy as np
import tensorflow as tf

def reset_graph(seed=1234567):
    tf.reset_default_graph()
    tf.set_random_seed(seed)
    np.random.seed(seed)

def firstGraph():

    print("\nCreating your first graph and running it in a session:")
    reset_graph()

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

