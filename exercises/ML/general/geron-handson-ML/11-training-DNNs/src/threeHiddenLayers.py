
import glob
import numpy      as np
import tensorflow as tf

from sklearn.metrics           import accuracy_score
from sklearn.preprocessing     import StandardScaler
from tensorflow.contrib.learn  import SKCompat, DNNClassifier, infer_real_valued_columns_from_input
from tensorflow.contrib.layers import fully_connected, batch_norm

##################################################
def threeHiddenLayers(
    mnistData, checkpointPATH,
    nInputs, nOutputs,
    nHidden1, nHidden2, nHidden3,
    learningRate, nEpochs, batchSize
    ):

    print("\n####################")
    print("threeHiddenLayers():\n")
    tf.reset_default_graph()

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print("\nConstruction Phase begins ...")

    X = tf.placeholder(tf.float32,shape=(None,nInputs),name="X")
    y = tf.placeholder(tf.int64,  shape=(None),        name="y")

    with tf.name_scope("dnn"):

        is_training = tf.placeholder(tf.bool, shape=(), name='is_training')
        bn_params = {
            'is_training'         : is_training,
            'decay'               : 0.99,
            'updates_collections' : None
            }

        hidden1 = tf.layers.dense(inputs=X,       units=nHidden1, activation=tf.nn.relu, name="hidden1")
        hidden2 = tf.layers.dense(inputs=hidden1, units=nHidden2, activation=tf.nn.relu, name="hidden2")
        hidden3 = tf.layers.dense(inputs=hidden2, units=nHidden3, activation=tf.nn.relu, name="hidden3")
        logits  = tf.layers.dense(inputs=hidden3, units=nOutputs, activation=None,       name="outputs")

    with tf.name_scope("loss"):
        xEntropy = tf.nn.sparse_softmax_cross_entropy_with_logits(labels=y,logits=logits)
        loss = tf.reduce_mean(xEntropy,name="loss")


    with tf.name_scope("train"):
        myOptimizer   = tf.train.GradientDescentOptimizer(learningRate)
        #trainingOp   = myOptimizer.minimize(loss)
        clipThreshold = 1.0
        gvs           = myOptimizer.compute_gradients(loss)
        cappedGVs     = [(tf.clip_by_value(grad,-clipThreshold,clipThreshold),var) for grad, var in gvs]
        trainingOp    = myOptimizer.apply_gradients(cappedGVs)

    with tf.name_scope("eval"):
        correct  = tf.nn.in_top_k(logits,y,1)
        accuracy = tf.reduce_mean(tf.cast(correct,tf.float32))

    myInitializer = tf.global_variables_initializer()
    mySaver       = tf.train.Saver()

    print("\nConstruction Phase complete.\n")

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print("\nTraining Execution Phase begins ...")

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
    else:
        print( "\nThe checkpoint\n" + checkpointPATH + "\nis found. No training is performed." )

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
    print("\nexiting: threeHiddenLayers()")
    print("####################")
    return( None )

