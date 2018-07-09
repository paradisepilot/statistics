
import glob
import numpy      as np
import tensorflow as tf

##################################################
def tfGetMNIST( mnistFILE ):

    print("\n### ~~~~~~~~~~~~ ###")
    print("tfGetMNIST():\n")

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    import os.path, pickle

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    if os.path.isfile(path = mnistFILE) == False :
        print("downloading TensorFlow MNIST data set from Internet ...")
        from tensorflow.examples.tutorials.mnist import input_data
        with open(file = mnistFILE, mode = 'wb') as myFile:
            pickle.dump(obj = input_data.read_data_sets('MNISTdata',one_hot=True), file = myFile)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print("loading TensorFlow MNIST data set from disk ...")
    with open(file = mnistFILE, mode = 'rb') as myFile:
        mnistData = pickle.load(myFile)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print("\n")
    print( "type(mnistData): "              + str(type(mnistData))              )
    print( "type(mnistData.train): "        + str(type(mnistData.train))        )
    print( "mnistData.train.num_examples: " + str(mnistData.train.num_examples) )
    print( "type(mnistData.validation): "   + str(type(mnistData.validation))   )
    print( "type(mnistData.test): "         + str(type(mnistData.test))         )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print("\nexiting: tfGetMNIST()")
    print("### ~~~~~~~~~~~~ ###")
    return( mnistData )

