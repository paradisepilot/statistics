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
# import seaborn (for improved graphics) if available
import importlib
from importlib.util import find_spec
seaborn_spec = importlib.util.find_spec(name="seaborn")
if seaborn_spec is not None:
    import seaborn as sns

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
import numpy   as np
import pandas  as pd

from scipy import stats

from examineData    import examineData
from splitTrainTest import splitTrainTest
from visualizeData  import visualizeData

from PipelinePreprocessHousingData import PipelinePreprocessHousingData

from sklearn.metrics         import mean_squared_error
from sklearn.linear_model    import LinearRegression
from sklearn.tree            import DecisionTreeRegressor
from sklearn.model_selection import cross_val_score

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
# linear model (this underfits the data)
linearModel = LinearRegression()
linearModel.fit(X = preprocessedStratTrainSet, y = stratifiedTrainSet["median_house_value"])

predictedHouseValues = linearModel.predict(X = preprocessedStratTrainSet)
linearMSE  = mean_squared_error(predictedHouseValues,stratifiedTrainSet["median_house_value"])
linearRMSE = np.sqrt(linearMSE)

print("\nlinearRMSE")
print(   linearRMSE )

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
# regression tree (this overfits the data: zero MSE)
regressionTreeModel = DecisionTreeRegressor()
regressionTreeModel.fit(X = preprocessedStratTrainSet, y = stratifiedTrainSet["median_house_value"])

predictedHouseValues = regressionTreeModel.predict(X = preprocessedStratTrainSet)
regressionTreeMSE  = mean_squared_error(predictedHouseValues,stratifiedTrainSet["median_house_value"])
regressionTreeRMSE = np.sqrt(regressionTreeMSE)

print("\nregressionTreeRMSE")
print(   regressionTreeRMSE )

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
# evaluate regression tree via 10-fold cross-validation
regressionTreeCVScores = cross_val_score(
    estimator = regressionTreeModel,
    X         = preprocessedStratTrainSet,
    y         = stratifiedTrainSet["median_house_value"],
    scoring   = "neg_mean_square_error",
    cv        = 10
    )
regressionTreeCVRMSE = np.sqrt( - regressionTreeCVScores )

print("\nregressionTreeCVRMSE")
print(   regressionTreeCVRMSE )

print("\nregressionTreeCVRMSE.mean()")
print(   regressionTreeCVRMSE.mean() )

print("\nregressionTreeCVRMSE.std()")
print(   regressionTreeCVRMSE.std() )

#################################################
#################################################

sys.exit(0)

