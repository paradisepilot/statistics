
import tensorflow as tf
import pandas as pd
import numpy as np
from sklearn.preprocessing import Imputer, StandardScaler

def reset_graph(seed=1234567):
    tf.reset_default_graph()
    tf.set_random_seed(seed)
    np.random.seed(seed)

def linearRegressionTF(housingData,housingTarget):

    print("\nLinear regression with TensorFlow:")
    reset_graph()

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    m,n = housingData.shape
    housing_data_plus_bias = np.c_[np.ones((m,1)),housingData]

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    X = tf.constant(housing_data_plus_bias,      dtype = tf.float32, name = "X")
    y = tf.constant(housingTarget.reshape(-1,1), dtype = tf.float32, name = "y")

    XT    = tf.transpose(X)
    theta = tf.matmul(tf.matmul(tf.matrix_inverse(tf.matmul(XT,X)),XT),y)

    with tf.Session() as mySession:
        theta_value = theta.eval()
        print("theta_value = " + str(theta_value))

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

