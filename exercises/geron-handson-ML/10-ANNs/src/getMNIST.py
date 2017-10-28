
import os.path, pickle
import numpy as np

def getMNIST( mnistFILE ):

    print("\n####################")
    print("getMNIST():\n")

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    if os.path.isfile(path = mnistFILE) == False :
        print("downloading MNIST data set from Internet ...")
        from sklearn.datasets import fetch_mldata
        with open(file = mnistFILE, mode = 'wb') as myFile:
            pickle.dump(obj = fetch_mldata('MNIST original'), file = myFile)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print("loading MNIST data set from disk ...")
    with open(file = mnistFILE, mode = 'rb') as myFile:
        mnist = pickle.load(myFile)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( mnist )

