
import numpy as np
from pandas import DataFrame
from sklearn.model_selection import train_test_split

def splitTrainTest(data,random_state):

    nrow = data["data"].shape[0]
    label_features = np.hstack(
        tup = (
            np.arange(nrow).reshape((nrow,1)),
            data['target'].reshape((nrow,1)),
            data['data']
            )
        )

    simpleTrainSet, simpleTestSet = train_test_split(
        DataFrame(data=label_features),
        test_size    = 1/7,
        random_state = random_state
        )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( simpleTrainSet, simpleTestSet )

