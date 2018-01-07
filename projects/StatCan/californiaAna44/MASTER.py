#!/usr/bin/env python

################################################################################
################################################################################
#
#  SYNOPSIS
#  --------
#  This Python program is a demo supervised machine learning pipeline. Its
#  purpose is to provide Statistics Canada colleagues a more or less generic
#  supervised machine learning workflow implemented in Python and executable
#  on Network A.
#
#  The implemented workflow is the one described in Chapter 2 of the following
#  book:
#
#      Aurélien Géron
#      Hands-On Machine Learning with Scikit-Learn & TensorFlow
#      O'Reilly, March 2017
#
#  We refer the user to the reference above for implemention and conceptual
#  details about this pipeline. We give here a brief summary of what the
#  pipeline does.
#
#  This pipeline contains an embedded data set, which is a table of housing
#  data at the level of census block group. This data set is based on the 1990
#  California census data. It is also downloadable from either of the following
#  two web sites:
#
#      1)  https://github.com/ageron/handson-ml/tree/master/datasets/housing
#      2)  https://www.kaggle.com/camnugent/california-housing-prices
#
#  This pipeline performs explorative analysis, visualization and basic
#  preprocessing on the embedded input data. It then uses functionalities from
#  Scikit-learn (a widely used machine learning Python library) to apply, with
#  default parameter settings, the following basic supervised machine learning
#  techniques:
#
#      i)  linear regression
#     ii)  regression trees
#    iii)  random forest regression
#
#  to fit models for predicting the variable "median_house_value," treating the
#  rest of the variables as predictors. Lastly, it fits an additional random
#  forests model, this time instead of simply using the default parameter
#  settings, the fitting procedure includes tuning of certain hyperparameters 
#  via cross validation. The performances of these fitted models is evaluated
#  by their prediction accuracy on a test data set.
#
#  AUTHOR
#  ------
#  Kenneth Chu, Statistics Canada (kenneth.chu@canada.ca)
#
################################################################################
################################################################################

import os, sys, shutil, getpass
import pprint, logging, datetime
import stat

thisScript = os.path.realpath(sys.argv[0])
dir_MASTER = os.path.dirname(thisScript)
dir_code   = os.path.join(dir_MASTER, "code")
dir_data   = os.path.join(dir_MASTER, "data")
dir_output = os.path.join(dir_MASTER, "output." + getpass.getuser())

if not os.path.exists(dir_output):
    os.makedirs(dir_output)

os.chdir(dir_output)
sys.stdout = open('log.stdout','w')
sys.stderr = open('log.stderr','w')

myTime = "system time: " + datetime.datetime.now().strftime("%c")
print( "\n" + myTime + "\n" )
print("####################")

logging.basicConfig(filename='log.debug',level=logging.DEBUG)

shutil.copy2( src = thisScript, dst = dir_output )
shutil.copytree(src = dir_code, dst = os.path.join(dir_output,"code"))

# append code directory to list of library paths
sys.path.append(dir_code)

##################################################
##################################################
# import seaborn (for improved graphics) if available
import importlib
from importlib.util import find_spec
seaborn_spec = importlib.util.find_spec(name="seaborn")
if seaborn_spec is not None:
    import seaborn as sns

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
import numpy  as np
import pandas as pd

from examineData       import examineData
from splitTrainTest    import splitTrainTest
from visualizeData     import visualizeData
from trainEvaluate     import trainEvaluate
from trainEvaluateGrid import trainEvaluateGrid

from PipelinePreprocessHousingData import PipelinePreprocessHousingData

from sklearn.linear_model import LinearRegression
from sklearn.tree         import DecisionTreeRegressor
from sklearn.ensemble     import RandomForestRegressor

#from sklearn.model_selection import GridSearchCV
ms_spec = importlib.util.find_spec(name="sklearn.model_selection")
if ms_spec is not None:
    from sklearn.model_selection import GridSearchCV
else:
    from sklearn.grid_search import GridSearchCV

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
# load data
housingFILE = os.path.join(dir_data,'housing.csv')
housingDF   = pd.read_csv(housingFILE);

# examine full data set
examineData(inputDF = housingDF);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
# split into training and testing data sets in a stratified manner
trainSet, testSet = splitTrainTest(inputDF = housingDF, random_state = 19)

# visualize stratified training data set
visualizeData(inputDF = trainSet);

print("\ntrainSet.info()")
print(   trainSet.info() )

print("\ntrainSet.describe()")
print(   trainSet.describe() )

print("\ntype(trainSet)")
print(   type(trainSet) )

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
# preprocess stratified training data set
preprocessedTrainSet = PipelinePreprocessHousingData.fit_transform(
    trainSet.drop(["median_house_value"],axis=1)
    )

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
# linear model (this underfits the data)
myLinearModel = LinearRegression()
trainEvaluate(
    trainData           = trainSet,
    testData            = testSet,
    trainedPreprocessor = PipelinePreprocessHousingData,
    myModel             = myLinearModel,
    modelName           = "Linear Model"
    )

# regression tree (this overfits the data: zero MSE)
myRegressionTreeModel = DecisionTreeRegressor()
trainEvaluate(
    trainData           = trainSet,
    testData            = testSet,
    trainedPreprocessor = PipelinePreprocessHousingData,
    myModel             = myRegressionTreeModel,
    modelName           = "Regression Tree"
    )

# random forest
myRandomForestModel = RandomForestRegressor()
trainEvaluate(
    trainData           = trainSet,
    testData            = testSet,
    trainedPreprocessor = PipelinePreprocessHousingData,
    myModel             = myRandomForestModel,
    modelName           = "Random Forest"
    )

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
# random forest with hyperparameter tuning via grid search
newRandomForestModel = RandomForestRegressor()

parameterGrid = [
    { 'n_estimators':[3,10,30], 'max_features':[2,4,6,8]                     },
    { 'n_estimators':[3,10],    'max_features':[2,3,4],  'bootstrap':[False] }
    ]

gridSearch = GridSearchCV(
    estimator  = newRandomForestModel,
    param_grid = parameterGrid,
    scoring    = "neg_mean_squared_error",
    cv         = 5
    )

trainEvaluateGrid(
    trainData           = trainSet,
    testData            = testSet,
    trainedPreprocessor = PipelinePreprocessHousingData,
    myModel             = gridSearch,
    modelName           = "Random Forest, Cross Validation, Grid Search"
    )

##################################################
##################################################
print("\n####################\n")
myTime = "system time: " + datetime.datetime.now().strftime("%c")
print( myTime + "\n" )

