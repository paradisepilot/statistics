
import numpy as np
import tensorflow as tf

def reset_graph(seed=1234567):
    tf.reset_default_graph()
    tf.set_random_seed(seed)
    np.random.seed(seed)

def manageGraphs():

    print("\nManaging graphs:")
    reset_graph()

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    x1 = tf.Variable(1)
    print("x1.graph is tf.get_default_graph()")
    print( x1.graph is tf.get_default_graph() )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    myGraph = tf.Graph()
    with myGraph.as_default():
        x2 = tf.Variable(2)

    print("x2.graph is tf.get_default_graph()")
    print( x2.graph is tf.get_default_graph() )

    print("x2.graph is myGraph")
    print( x2.graph is myGraph )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

