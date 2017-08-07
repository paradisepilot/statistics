
import numpy as np

from sklearn.metrics       import mean_squared_error
from sklearn.preprocessing import LabelEncoder

def trainEvaluateGrid(trainData, testData, trainedPreprocessor, myModel, modelName):

    preprocessedTrainData = trainedPreprocessor.transform(
        trainData.drop(["median_house_value"],axis=1)
        )

    myModel.fit(X = preprocessedTrainData, y = trainData["median_house_value"])
    myPredictions = myModel.predict(X = preprocessedTrainData)

    myTrainMSE  = mean_squared_error(myPredictions,trainData["median_house_value"])
    myTrainRMSE = np.sqrt(myTrainMSE)

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

    print("\n(Cross Validation, Grid Search) RSME:")
    gridScores = myModel.grid_scores_

    print("\ngridScores")
    for tempItem in enumerate(gridScores):
        print( tempItem )

    print("\nbest_params_:")
    print(   myModel.best_params_ )

    print("\ngridSearch.best_estimator_")
    print(   myModel.best_estimator_ )

    print("\nTest RMSE: " + str(myTestRMSE))

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    # examine feature importances
    featureImportances = myModel.best_estimator_.feature_importances_

    numericAttribs = list(trainData.drop(["ocean_proximity"],axis=1).columns)

    oneHotEncoder     = LabelEncoder()
    housingCatEncoded = oneHotEncoder.fit(trainData["ocean_proximity"])
    oneHotAttribs     = oneHotEncoder.classes_

    extraAttribs = ["roomsPerHhold", "popPerHhold", "bedroomsPerRoom"]
    attributes = list(numericAttribs) + extraAttribs + list(oneHotAttribs)

    print("\nfeatureImportances")
    for currentItem in sorted(zip(featureImportances,attributes),reverse=True):
        print( currentItem )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

