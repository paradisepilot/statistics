
import os.path
import numpy as np

def getMNIST( mnistFILE ):

    if os.path.isfile(path = mnistFILE) == True :
        mnist = np.load(file = mnistFILE)
    else :
        from sklearn.datasets import fetch_mldata
        mnist = fetch_mldata('MNIST original')
        np.save(file = mnistFILE, arr = mnist)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( mnist )

