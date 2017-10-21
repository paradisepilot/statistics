
import tensorflow as tf
import numpy as np
from datetime import datetime

def myReLU(X):
    with tf.name_scope("relu"):
        wShape = (int(X.get_shape()[1]),1)
        w = tf.Variable(tf.random_normal(wShape),name="weights")
        b = tf.Variable(0.0,name="bias")
        z = tf.add(tf.matmul(X,w),b,name="z")
        return( tf.maximum(z,0.,name="ReLU") )

def modularity():

    print("\nModularity:")

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    # create log directory for TensorBoard
    logROOT   = "./TFlogs"
    timestamp = datetime.utcnow().strftime("%Y%m%d%H%M%S")
    logDIR    = "{}/run-{}/".format(logROOT,timestamp)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    nFeatures = 3
    X         = tf.placeholder(tf.float32,shape=(None,nFeatures),name="X")
    ReLUs     = [myReLU(X) for i in range(5)]
    output    = tf.add_n(ReLUs,name="output")

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    fileWriter = tf.summary.FileWriter(logDIR,tf.get_default_graph())

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    fileWriter.close()
    return( None )

