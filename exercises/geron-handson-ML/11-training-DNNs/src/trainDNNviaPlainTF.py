
import glob
import numpy      as np
import tensorflow as tf

from sklearn.metrics           import accuracy_score
from sklearn.preprocessing     import StandardScaler
from tensorflow.contrib.learn  import SKCompat, DNNClassifier, infer_real_valued_columns_from_input
from tensorflow.contrib.layers import fully_connected, batch_norm

##################################################
def tfGetMNIST( mnistFILE ):

    print("\n### ~~~~~~~~~~~~ ###")
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
    print("\nexiting: tfGetMNIST()")
    print("### ~~~~~~~~~~~~ ###")
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
def leakyReLU(z, name=None):
    return( tf.maximum(0.01*z,z,name=name) )

##################################################
def trainDNNviaPlainTF( mnistFILE, checkpointPATH, nHidden1, nHidden2, learningRate, nEpochs, batchSize):

    print("\n####################")
    print("trainDNNviaPlainTF():\n")

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print("\nConstruction Phase begins ...")

    nInputs  = 28 * 28
    nOutputs = 10

    X = tf.placeholder(tf.float32,shape=(None,nInputs),name="X")
    y = tf.placeholder(tf.int64,  shape=(None),        name="y")

    with tf.name_scope("dnn"):
        #hidden1 = neuronLayer(X,      nHidden1,"hidden1",activation="relu")
        #hidden2 = neuronLayer(hidden1,nHidden2,"hidden2",activation="relu")
        #logits  = neuronLayer(hidden2,nOutputs,"outputs")

        He_initializer = tf.contrib.layers.variance_scaling_initializer()
        is_training = tf.placeholder(tf.bool, shape=(), name='is_training')
        bn_params = {
            'is_training'         : is_training,
            'decay'               : 0.99,
            'updates_collections' : None
            }

        hidden1 = fully_connected(
            inputs              = X,
            num_outputs         = nHidden1,
            activation_fn       = leakyReLU, # tf.nn.elu,
            weights_initializer = He_initializer,
            normalizer_fn       = batch_norm,
            normalizer_params   = bn_params,
            scope               = "hidden1"
            )

        hidden2 = fully_connected(
            inputs            = hidden1,
            num_outputs       = nHidden2,
            normalizer_fn     = batch_norm,
            normalizer_params = bn_params,
            scope             = "hidden2"
            )

        logits = fully_connected(
            inputs            = hidden2,
            num_outputs       = nOutputs,
            activation_fn     = None,
            normalizer_fn     = batch_norm,
            normalizer_params = bn_params,
            scope             = "outputs"
            )

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
    print("\nTraining Execution Phase begins ...")

    mnistData = tfGetMNIST( mnistFILE = mnistFILE )
    print("\n")
    print( "type(mnistData): "              + str(type(mnistData))              )
    print( "type(mnistData.train): "        + str(type(mnistData.train))        )
    print( "mnistData.train.num_examples: " + str(mnistData.train.num_examples) )
    print( "type(mnistData.validation): "   + str(type(mnistData.validation))   )
    print( "type(mnistData.test): "         + str(type(mnistData.test))         )

    X_test = mnistData.test.images
    y_test = mnistData.test.labels
    y_test = np.matmul(y_test,np.arange(y_test.shape[1])).astype('int')

    tempWildCard = checkpointPATH + "*"
    print("\n")
    print( "tempWildCard: " + tempWildCard )
    print('glob.glob(checkpointPATH + "*")')
    print( glob.glob(checkpointPATH + "*") )
    print('len(glob.glob(checkpointPATH + "*")): ' + str(len(glob.glob(checkpointPATH + "*"))) )

    if (len(glob.glob(checkpointPATH + "*")) < 1):
        print( "\nperforming batch gradient descent ..." )
        with tf.Session() as mySession:
            myInitializer.run()
            for epoch in range(nEpochs):
                for iteration in range(mnistData.train.num_examples // batchSize):
                    X_batch, y_batch = mnistData.train.next_batch(batchSize)
                    y_batch = np.matmul(y_batch,np.arange(y_batch.shape[1])).astype('int')
                    mySession.run(trainingOp, feed_dict={is_training:True, X:X_batch,y:y_batch})
                accuracyTrain = accuracy.eval(feed_dict={is_training:True, X:X_batch,y:y_batch})
                accuracyTest  = accuracy.eval(feed_dict={is_training:False,X:X_test, y:y_test })
                print("epoch: ", epoch, ", accuracy(train): ", accuracyTrain, ", accuracy(test): ", accuracyTest)
            savePath = mySaver.save(mySession,checkpointPATH)

    print("\nTraining Execution Phase complete.")

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print("\nDeployment Execution Phase begins ...")

    with tf.Session() as mySession:
        mySaver.restore(mySession,checkpointPATH)
        print( "type(logits): " + str(type(logits)) )
        accuracyTest  = accuracy.eval(feed_dict={is_training:False,X:X_test, y:y_test })
        print("Deployment: accuracy(test): ", accuracyTest)

    print("\nDeployment Execution Phase complete.")

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print("\nexiting: trainDNNviaPlainTF()")
    print("####################")
    return( None )

