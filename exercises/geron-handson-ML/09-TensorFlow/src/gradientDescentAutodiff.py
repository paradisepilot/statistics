
import tensorflow as tf
import numpy as np
from sklearn.datasets      import fetch_california_housing
from sklearn.preprocessing import StandardScaler

def gradientDescentAutodiff(nEpochs,learningRate,pageSize):

    print("\nGradient Descent using TensorFlow Autodiff:")

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    myScaler = StandardScaler()

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    housing = fetch_california_housing()
    m,n = housing.data.shape

    scaled_housing_data = myScaler.fit_transform(housing.data)
    scaled_housing_data_plus_bias = np.c_[np.ones((m,1)),scaled_housing_data]

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    X = tf.constant(scaled_housing_data_plus_bias, dtype=tf.float32, name="X")
    y = tf.constant(housing.target.reshape(-1,1),  dtype=tf.float32, name="y")

    theta = tf.Variable(tf.random_uniform([n+1,1], -1.0, 1.0), name="theta")
    yPredicted = tf.matmul(X,theta,name="predictions")

    error = yPredicted - y
    MSE = tf.reduce_mean(tf.square(error),name="MSE")
    #gradients = (2/m) * tf.matmul(tf.transpose(X),error)
    gradients = tf.gradients(MSE,[theta])[0]
    trainingOp = tf.assign(theta, theta - learningRate * gradients)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    init = tf.global_variables_initializer()
    with tf.Session() as mySession:
        mySession.run(init)
        for epoch in range(nEpochs):
            if epoch % pageSize == 0:
                print("Epoch: " + str(epoch) + ", MSE = " + str(MSE.eval()))
            mySession.run(trainingOp)
        bestTheta = theta.eval()

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print("bestTheta: " + str(bestTheta))

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

