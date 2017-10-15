
import tensorflow as tf
import numpy as np
from datetime import datetime
from sklearn.preprocessing import StandardScaler

def fetchBatch(X,y,batchIndex,batchSize):
    startIndex = batchIndex * batchSize
    endIndex   = min(X.shape[0], (batchIndex+1) * batchSize)
    X_batch    = X[startIndex:endIndex,]
    y_batch    = y[startIndex:endIndex].reshape(-1,1)
    return( X_batch , y_batch )

def gradientDescentMiniBatch(housingData,housingTarget,nEpochs,learningRate,pageSize,logFrequency,outDIR):

    print("\nMini-batch Gradient Descent using Placeholder:")

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    # create log directory for TensorBoard
    logROOT = "./TFlogs"
    #if not os.path.exists(logROOT):
    #    os.makedirs(logROOT)
    timestamp = datetime.utcnow().strftime("%Y%m%d%H%M%S")
    logDIR    = "{}/run-{}/".format(logROOT,timestamp)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    m , n     = housingData.shape
    batchSize = 100
    nBatches  = int(np.ceil(m/batchSize))
    print( "nrow:" + str(m) + ", ncol: " + str(n) + ", nBatches: " + str(nBatches) )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    myScaler = StandardScaler()
    scaled_housing_data = myScaler.fit_transform(housingData)
    scaled_housing_data_plus_bias = np.c_[np.ones((m,1)),scaled_housing_data]

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    theta = tf.Variable(tf.random_uniform([n+1,1], -1.0, 1.0), name="theta")

    #X = tf.constant(scaled_housing_data_plus_bias, dtype=tf.float32, name="X")
    #y = tf.constant(housingTarget.reshape(-1,1),   dtype=tf.float32, name="y")
    X = tf.placeholder(dtype=tf.float32, shape=(None,n+1), name="X")
    y = tf.placeholder(dtype=tf.float32, shape=(None,  1), name="y")

    yPredicted = tf.matmul(X,theta,name="predictions")

    error = yPredicted - y
    MSE   = tf.reduce_mean(tf.square(error),name="MSE")

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    myOptimizer = tf.train.GradientDescentOptimizer(learning_rate=learningRate)
    trainingOp  = myOptimizer.minimize(MSE)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    init = tf.global_variables_initializer()

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    mseSummary = tf.summary.scalar("MSE",MSE)
    fileWriter = tf.summary.FileWriter(logDIR,tf.get_default_graph())

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    with tf.Session() as mySession:
        mySession.run(init)
        for epoch in range(nEpochs):
            if epoch % pageSize == 0:
                print( "epoch: " + str(epoch) ) # Printing the MSE here would generate an error; why?
            for batchIndex in range(nBatches):
                X_batch, y_batch = fetchBatch(
                    X          = scaled_housing_data_plus_bias,
                    y          = housingTarget,
                    batchIndex = batchIndex,
                    batchSize  = batchSize
                    )
                if batchIndex % logFrequency == 0:
                    summaryStr = mseSummary.eval(feed_dict={X:X_batch,y:y_batch})
                    step       = epoch * nBatches + batchIndex
                    fileWriter.add_summary(summaryStr,step)
                mySession.run(trainingOp,feed_dict={X:X_batch,y:y_batch})
        bestTheta = theta.eval()

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print("bestTheta: " + str(bestTheta))

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    fileWriter.close()
    return( None )

