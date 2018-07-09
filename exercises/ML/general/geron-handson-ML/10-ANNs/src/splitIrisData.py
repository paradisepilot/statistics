
import numpy as np
from sklearn.model_selection import train_test_split

##############################
def splitIrisData( irisData, testSize, randomState ):

    print("\n### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###")
    print("splitIrisData()\n")

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    irisFull = np.c_[ irisData.data, irisData.target ]
    print( "type(irisFull)" + str(type(irisFull)) )
    print( "irisFull.shape" + str(irisFull.shape) )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    trainSet, testSet = train_test_split(
        irisFull,
        test_size    = testSize,
        random_state = randomState
        )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    X_train = trainSet[:,0:4]
    y_train = trainSet[:,4]

    X_test = testSet[:,0:4]
    y_test = testSet[:,4]

    print( "X_train.shape: " + str(X_train.shape) + ", y_train.shape: " + str(y_train.shape) )
    print( "X_test.shape: "  + str(X_test.shape ) + ", y_test.shape: "  + str(y_test.shape ) )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( X_train, y_train, X_test, y_test )

##############################

