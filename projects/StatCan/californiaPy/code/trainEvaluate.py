
import numpy as np
from sklearn.metrics import mean_squared_error
# from sklearn.model_selection import cross_val_score

import importlib
from importlib.util import find_spec
ms_spec = importlib.util.find_spec(name="sklearn.model_selection")
if ms_spec is not None:
    from sklearn.model_selection import cross_val_score
else:
    from sklearn.cross_validation import cross_val_score

###################################################
def trainEvaluate(trainData, testData, trainedPreprocessor, myModel, modelName):

    preprocessedTrainData = trainedPreprocessor.transform(
        trainData.drop(["median_house_value"],axis=1)
        )

    myModel.fit(X = preprocessedTrainData, y = trainData["median_house_value"])
    myPredictions = myModel.predict(X = preprocessedTrainData)

    myTrainMSE  = mean_squared_error(myPredictions,trainData["median_house_value"])
    myTrainRMSE = np.sqrt(myTrainMSE)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    nFold =10

    CVScores = cross_val_score(
        estimator = myModel,
        X         = preprocessedTrainData,
        y         = trainData["median_house_value"],
        scoring   = "neg_mean_squared_error",
        cv        = nFold
        )
    CVRMSE = np.sqrt( - CVScores )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    preprocessedTestData = trainedPreprocessor.transform(
        testData.drop(["median_house_value"],axis=1)
        )

    myPredictions = myModel.predict(X = preprocessedTestData)

    myTestMSE  = mean_squared_error(myPredictions,testData["median_house_value"])
    myTestRMSE = np.sqrt(myTestMSE)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print("\n### ~~~~~~~~~~~~~~~~~~~~ ###")
    print("###  " + modelName)

    print("\nTrain RMSE: " + str(myTrainRMSE))

    print("\nCV RMSE (" + str(nFold) + "-fold):")
    print(CVRMSE)
    print("\nCV RMSE (mean): " + str(CVRMSE.mean()) )
    print("\nCV RMSE (std): "  + str(CVRMSE.std())  )

    print("\nTest RMSE: " + str(myTestRMSE))

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

