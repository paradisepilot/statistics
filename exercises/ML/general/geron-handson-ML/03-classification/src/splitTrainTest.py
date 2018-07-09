
import numpy as np
from math import sqrt
from pandas import DataFrame
from sklearn.model_selection import train_test_split

def getColnames(ncolSquared):
    ncol = int(sqrt(ncolSquared))
    X = 1 + np.indices((ncol,ncol))
    rowIndices = X[0].astype('|S2')
    colIndices = X[1].astype('|S2')
    commaMAT = np.chararray(X[0].shape) ; commaMAT[:] = ','
    elementIndices = np.core.defchararray.add(np.core.defchararray.add(rowIndices,commaMAT),colIndices)
    elementIndices = elementIndices.reshape(1,ncolSquared).tolist()[0]
    return( elementIndices )

def splitTrainTest(data,random_state):

    nrow = data["data"].shape[0]
    ncol = data["data"].shape[1]

    label_features = np.hstack(
        tup = (
            np.arange(nrow).reshape((nrow,1)),
            data['target'].reshape((nrow,1)),
            data['data']
            )
        )

    label_features = DataFrame(data=label_features)
    label_features.columns = ['index','label'] + getColnames(ncolSquared = ncol)

    simpleTrainSet, simpleTestSet = train_test_split(
        label_features,
        test_size    = 1/7,
        random_state = random_state
        )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    del label_features
    return( simpleTrainSet, simpleTestSet )

