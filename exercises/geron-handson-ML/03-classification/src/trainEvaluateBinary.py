
import numpy as np
from NeverFiveClassifier     import NeverFiveClassifier
from sklearn.metrics         import confusion_matrix
from sklearn.metrics         import precision_score, recall_score, f1_score
from sklearn.model_selection import cross_val_score, cross_val_predict

###################################################
def trainEvaluateBinary(trainData, testData, myModel):

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
    if (isinstance(myModel,NeverFiveClassifier)):
        myPrecision = None
        myRecall    = None
        myF1        = None
    else:
        myPrecision = precision_score(
            y_true = trainData.loc[:,"isFive"],
            y_pred = myPredictions
            )

        myRecall = recall_score(
            y_true = trainData.loc[:,"isFive"],
            y_pred = myPredictions
            )

        myF1 = f1_score(
            y_true = trainData.loc[:,"isFive"],
            y_pred = myPredictions
            )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print("\n### ~~~~~~~~~~~~~~~~~~~~ ###")
    print('type(myModel)')
    print( type(myModel) )

    print("\nCV Accuracy (" + str(nFold) + "-fold):")
    print(myCVAccuracy)

    print("\nConfusion Matrix:")
    print(myConfusionMatrix)

    print("\nPrecision:")
    print(myPrecision)

    print("\nRecall:")
    print(myRecall)

    print("\nF1 Score:")
    print(myF1)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

