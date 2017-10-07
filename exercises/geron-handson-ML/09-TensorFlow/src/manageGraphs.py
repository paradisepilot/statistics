
import tensorflow as tf

def manageGraphs():

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

