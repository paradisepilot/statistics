
import tensorflow as tf

def nodeValueLifecycle():

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    w = tf.constant(3)
    x = w + 2
    y = x + 5
    z = x * 3

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    with tf.Session() as mySession:
        print("y.eval()")
        print( y.eval() )

        print("z.eval()")
        print( z.eval() )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

