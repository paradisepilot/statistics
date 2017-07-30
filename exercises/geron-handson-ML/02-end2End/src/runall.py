#!/usr/bin/env python

import os, stat, sys

thisScript = sys.argv[0]
srcDIR     = sys.argv[1]
datDIR     = sys.argv[2]
outDIR     = sys.argv[3]

# append module path with srcDIR
sys.path.append(srcDIR)

# change directory to outDIR
os.chdir(outDIR)

#################################################
#################################################
import numpy   as np
import pandas  as pd
import seaborn as sns

from scipy import stats

from examineData    import examineData
from splitTrainTest import splitTrainTest
from visualizeData  import visualizeData

from PipelinePreprocessHousingData import PipelinePreprocessHousingData

from sklearn.linear_model import LinearRegression
from sklearn.metrics      import mean_squared_error

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
# load data
housingFILE = os.path.join(datDIR,'housing.csv')
housingDF   = pd.read_csv(housingFILE);

# examine full data set
examineData(inputDF = housingDF);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
# split into training and testing data sets in a stratified manner
stratifiedTrainSet, stratifiedTestSet = splitTrainTest(inputDF = housingDF, random_state = 19)

# visualize stratified training data set
visualizeData(inputDF = stratifiedTrainSet);

print("\nstratifiedTrainSet.info()")
print(   stratifiedTrainSet.info() )

print("\nstratifiedTrainSet.describe()")
print(   stratifiedTrainSet.describe() )

print("\ntype(stratifiedTrainSet)")
print(   type(stratifiedTrainSet) )

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
# preprocess stratified training data set
preprocessedStratTrainSet = PipelinePreprocessHousingData.fit_transform(
    stratifiedTrainSet.drop(["median_house_value"],axis=1)
    )

print("\npreprocessedStratTrainSet.shape")
print(   preprocessedStratTrainSet.shape )

print("\nstats.describe(preprocessedStratTrainSet)")
print(   stats.describe(preprocessedStratTrainSet) )

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
# linear model
linearModel = LinearRegression()
linearModel.fit(X = preprocessedStratTrainSet, y = stratifiedTrainSet["median_house_value"])

predictedHouseValues = linearModel.predict(X = preprocessedStratTrainSet)
linearMSE  = mean_squared_error(predictedHouseValues,stratifiedTrainSet["median_house_value"])
linearRMSE = np.sqrt(linearMSE)

print("\nlinearRMSE")
print(   linearRMSE )

#################################################
#################################################

sys.exit(0)

