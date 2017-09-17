
import numpy as np
from sklearn.metrics import mean_squared_error
from sklearn.model_selection import cross_val_score

###################################################
def trainEvaluateBinary(trainData, testData, myModel, modelName):

    featureColumns = trainData.columns.tolist()
    featureColumns.remove('index')
    featureColumns.remove('label')

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    trainData['isFive'] = (trainData.loc[:,'label'] == 5)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    myModel.fit(
        X = trainData.loc[:,featureColumns],
        y = trainData.loc[:,'isFive']
        )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    nFold = 10

    cvAccuracy = cross_val_score(
        estimator = myModel,
        X         = trainData.loc[:,featureColumns],
        y         = trainData.loc[:,"isFive"],
        scoring   = "accuracy",
        cv        = nFold
        )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print("\n### ~~~~~~~~~~~~~~~~~~~~ ###")
    print("###  " + modelName)

    print("\nCV Accuracy (" + str(nFold) + "-fold):")
    print(cvAccuracy)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

