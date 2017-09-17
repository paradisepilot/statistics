
import numpy as np
from sklearn.metrics         import confusion_matrix
from sklearn.model_selection import cross_val_score, cross_val_predict

###################################################
def trainEvaluateBinary(trainData, testData, myModel, modelName):

    featureColumns = trainData.columns.tolist()
    featureColumns.remove('index')
    featureColumns.remove('label')

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    trainData['isFive'] = (trainData.loc[:,'label'] == 5)
    myModel.fit(
        X = trainData.loc[:,featureColumns],
        y = trainData.loc[:,'isFive']
        )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    nFold = 10
    myCVAccuracy = cross_val_score(
        estimator = myModel,
        X         = trainData.loc[:,featureColumns],
        y         = trainData.loc[:,"isFive"],
        scoring   = "accuracy",
        cv        = nFold
        )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    myPredictions = cross_val_predict(
        estimator = myModel,
        X         = trainData.loc[:,featureColumns],
        y         = trainData.loc[:,"isFive"],
        cv        = nFold
        )

    myConfusionMatrix = confusion_matrix(
        y_true = trainData.loc[:,"isFive"],
        y_pred = myPredictions
        )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print("\n### ~~~~~~~~~~~~~~~~~~~~ ###")
    print("###  " + modelName)

    print("\nCV Accuracy (" + str(nFold) + "-fold):")
    print(myCVAccuracy)

    print("\nConfusion Matrix (" + str(nFold) + "-fold):")
    print(myConfusionMatrix)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

