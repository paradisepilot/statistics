
import tensorflow as tf
import pandas as pd
import numpy as np
from sklearn.preprocessing import Imputer, StandardScaler

def linearRegressionTF(housingData,housingTarget):

    print("\nLinear regression with TensorFlow:")

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

