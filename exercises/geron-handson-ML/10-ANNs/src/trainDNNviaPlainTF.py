
import numpy      as np
import tensorflow as tf

from sklearn.metrics           import accuracy_score
from sklearn.preprocessing     import StandardScaler
from tensorflow.contrib.learn  import SKCompat, DNNClassifier, infer_real_valued_columns_from_input
from tensorflow.contrib.layers import fully_connected

##################################################
def tfGetMNIST( mnistFILE ):

    print("\n####################")
    print("tfGetMNIST():\n")

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    import os.path, pickle
    if os.path.isfile(path = mnistFILE) == False :
        print("downloading TensorFlow MNIST data set from Internet ...")
        from tensorflow.examples.tutorials.mnist import input_data
        with open(file = mnistFILE, mode = 'wb') as myFile:
            pickle.dump(obj = input_data.read_data_sets('MNISTdata',one_hot=True), file = myFile)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print("loading TensorFlow MNIST data set from disk ...")
    with open(file = mnistFILE, mode = 'rb') as myFile:
        mnist = pickle.load(myFile)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( mnist )

##################################################
def neuronLayer(X, nNeurons, name, activation=None):
    with tf.name_scope(name):
        nInputs = int(X.get_shape()[1])
        stddev  = 2 / np.sqrt(nInputs)
        init    = tf.truncated_normal((nInputs,nNeurons),stddev=stddev)
        W       = tf.Variable(init,name="weights")
        b       = tf.Variable(tf.zeros([nNeurons]),name="biases")
        z       = tf.matmul(X,W) + b
        if activation == "relu":
            return( tf.nn.relu(z) )
        else:
            return( z )

##################################################
def trainDNNviaPlainTF( mnistFILE ):

    print("\n####################")
    print("trainDNNviaPlainTF():\n")

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print("\nConstruction Phase begins ...")

    nInputs      = 28 * 28
    nHidden1     = 300
    nHidden2     = 100
    nOutputs     = 10
    learningRate = 0.01

    X = tf.placeholder(tf.float32,shape=(None,nInputs),name="X")
    y = tf.placeholder(tf.int64,  shape=(None),       name="y")

    with tf.name_scope("dnn"):
        #hidden1 = neuronLayer(X,      nHidden1,"hidden1",activation="relu")
        #hidden2 = neuronLayer(hidden1,nHidden2,"hidden2",activation="relu")
        #logits  = neuronLayer(hidden2,nOutputs,"outputs")
        hidden1 = fully_connected(X,      nHidden1,scope="hidden1")
        hidden2 = fully_connected(hidden1,nHidden2,scope="hidden2")
        logits  = fully_connected(hidden2,nOutputs,scope="outputs",activation_fn=None)

    with tf.name_scope("loss"):
        xEntropy = tf.nn.sparse_softmax_cross_entropy_with_logits(labels=y,logits=logits)
        loss = tf.reduce_mean(xEntropy,name="loss")


    with tf.name_scope("train"):
        myOptimizer = tf.train.GradientDescentOptimizer(learningRate)
        trainingOp  = myOptimizer.minimize(loss)

    with tf.name_scope("eval"):
        correct  = tf.nn.in_top_k(logits,y,1)
        accuracy = tf.reduce_mean(tf.cast(correct,tf.float32))

    myInitializer = tf.global_variables_initializer()
    mySaver       = tf.train.Saver()

    print("\nConstruction Phase complete.\n")

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print("\nExecution Phase begins ...")

    mnistData = tfGetMNIST( mnistFILE = mnistFILE )
    print( "type(mnistData): "              + str(type(mnistData))              )
    print( "type(mnistData.train): "        + str(type(mnistData.train))        )
    print( "mnistData.train.num_examples: " + str(mnistData.train.num_examples) )
    print( "type(mnistData.validation): "   + str(type(mnistData.validation))   )
    print( "type(mnistData.test): "         + str(type(mnistData.test))         )

    nEpochs   = 20
    batchSize = 50

    X_test = mnistData.test.images
    y_test = mnistData.test.labels
    y_test = np.matmul(y_test,np.arange(y_test.shape[1])).astype('int')

    with tf.Session() as mySession:
        myInitializer.run()
        for epoch in range(nEpochs):
            for iteration in range(mnistData.train.num_examples // batchSize):
                X_batch, y_batch = mnistData.train.next_batch(batchSize)
                y_batch = np.matmul(y_batch,np.arange(y_batch.shape[1])).astype('int')
                mySession.run(trainingOp,feed_dict={X:X_batch,y:y_batch})
            accuracyTrain = accuracy.eval(feed_dict={X:X_batch,y:y_batch})
            accuracyTest  = accuracy.eval(feed_dict={X:X_test, y:y_test })
            print("epoch: ", epoch, ", accuracy(train): ", accuracyTrain, ", accuracy(test): ", accuracyTest)
        savePath = mySaver.save(mySession,"my_model_final.ckpt")

    print("\nExecution Phase complete.")

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    #y_predicted = clfDNN.predict(X_test_scaled)
    #y_predicted = y_predicted['classes']
    #print( "type(y_predicted): " + str(type(y_predicted)) )
    #print( "y_predicted:" )
    #print(  y_predicted   )
    #print( "y_predicted.shape: " + str(y_predicted.shape) )

    #print( "accuracy_score(y_test,y_predicted): " + str(accuracy_score(y_test,y_predicted)) )

    #print("clfDNN.evaluate(X_test_scaled,y_test)")
    #print( clfDNN.evaluate(X_test_scaled,y_test) )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

