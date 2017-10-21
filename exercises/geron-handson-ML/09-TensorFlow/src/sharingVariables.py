
import tensorflow as tf
import numpy as np
from datetime import datetime

def reset_graph(seed=1234567):
    tf.reset_default_graph()
    tf.set_random_seed(seed)
    np.random.seed(seed)

def sharingVariables1():

    print("\nSharing Variables (instantiate threshold prior to calling ReLU):")
    reset_graph()

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    def myReLU(X):
        with tf.variable_scope("relu",reuse=True):
            threshold = tf.get_variable("threshold")
            wShape = (int(X.get_shape()[1]),1)
            w = tf.Variable(tf.random_normal(wShape),name="weights")
            b = tf.Variable(0.0,name="bias")
            z = tf.add(tf.matmul(X,w),b,name="z")
            return( tf.maximum(z,0.,name="ReLU") )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    # create log directory for TensorBoard
    logROOT   = "./TFlogs"
    timestamp = datetime.utcnow().strftime("%Y%m%d%H%M%S")
    logDIR    = "{}/run-{}/".format(logROOT,timestamp)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    nFeatures = 3
    X = tf.placeholder(tf.float32,shape=(None,nFeatures),name="X")
    with tf.variable_scope("relu"):
        threshold = tf.get_variable("threshold",shape=(),initializer=tf.constant_initializer(0.0))
    ReLUs  = [myReLU(X) for i in range(5)]
    output = tf.add_n(ReLUs,name="output")

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    fileWriter = tf.summary.FileWriter(logDIR,tf.get_default_graph())

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    fileWriter.close()
    return( None )

def sharingVariables2():

    print("\nSharing Variables (instantiate threshold during first call to ReLU):")
    reset_graph()

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    def myReLU(X):
        threshold = tf.get_variable("threshold",shape=(),initializer=tf.constant_initializer(0.0))
        wShape = (int(X.get_shape()[1]),1)
        w = tf.Variable(tf.random_normal(wShape),name="weights")
        b = tf.Variable(0.0,name="bias")
        z = tf.add(tf.matmul(X,w),b,name="z")
        return( tf.maximum(z,0.,name="ReLU") )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    # create log directory for TensorBoard
    logROOT   = "./TFlogs"
    timestamp = datetime.utcnow().strftime("%Y%m%d%H%M%S")
    logDIR    = "{}/run-{}/".format(logROOT,timestamp)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    nFeatures = 3
    X = tf.placeholder(tf.float32,shape=(None,nFeatures),name="X")
    ReLUs = []
    for reluIndex in range(5):
        with tf.variable_scope("relu",reuse=(reluIndex > 0)) as scope:
            ReLUs.append(myReLU(X))
    output = tf.add_n(ReLUs,name="output")

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    fileWriter = tf.summary.FileWriter(logDIR,tf.get_default_graph())

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    fileWriter.close()
    return( None )

