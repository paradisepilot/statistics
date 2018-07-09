
import numpy as np
import tensorflow as tf

def reset_graph(seed=1234567):
    tf.reset_default_graph()
    tf.set_random_seed(seed)
    np.random.seed(seed)

def nodeValueLifecycle():

    print("\nLifecyle of a node value:")
    reset_graph()

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    w = tf.constant(3)
    x = w + 2
    y = x + 5
    z = x * 3

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    with tf.Session() as mySession:
        #print("y.eval(): " + str(y.eval()) )
        #print("z.eval(): " + str(z.eval()) )

        y_val, z_val = mySession.run([y,z]);
        print("y_val: " + str(y_val))
        print("z_val: " + str(z_val))

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

