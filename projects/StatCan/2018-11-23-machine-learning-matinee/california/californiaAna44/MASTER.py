#!/usr/bin/env python

################################################################################
################################################################################
#
#  SYNOPSIS
#  ========
#  This Python program (MASTER.py) is a demo supervised machine learning
#  pipeline. Its purpose is to provide Statistics Canada colleagues a more or
#  less generic supervised machine learning workflow implemented in Python and
#  executable on Network A.
#
#  The implemented workflow follows closely the one described in Chapter 2 of
#  the following book:
#
#      Aurélien Géron
#      Hands-On Machine Learning with Scikit-Learn & TensorFlow
#      O'Reilly, March 2017
#
#  We refer the user to the reference above for implemention and conceptual
#  details. We give here only a brief summary of what the pipeline does.
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
#  preprocessing on the embedded data. It then uses functionalities from
#  Scikit-learn (a widely used machine learning Python library) to apply, with
#  default parameter settings, the following basic supervised machine learning
#  techniques:
#
#      i)  linear regression
#     ii)  regression trees
#    iii)  random forest regression
#
#  in order to fit models for predicting the variable "median_house_value,"
#  treating the #  rest of the variables as predictors. Lastly, it fits an
#  additional random forests model, this time instead of simply using the
#  default parameter settings, the fitting procedure includes tuning of certain
#  hyperparameters via cross validation.
#
#  The performances of these fitted models is evaluated by their prediction
#  accuracy on a test data set.
#
#  AUTHOR
#  ======
#  Kenneth Chu, ICCSMD, Statistics Canada (kenneth.chu@canada.ca)
#
#  RELEASE DATE
#  ============
#  February 20, 2018
#
#  EXECUTION INSTRUCTIONS
#  ======================
#  For how to execute this pipeline (MASTER.py), follow the instructions in
#  the README file, namely:
#
#      ./README.txt
#
#  INPUT
#  =====
#  This pipeline contains a single (input) tabular data file in CSV format:
#
#    1)  ./data/housing.csv
#
#        This CSV file contains 20640 non-header rows. Each row contains data
#        for a census block group from the 1990 California census data. This
#        file contains columns with the following headers:
#
#            longitude
#            latitude
#            housing_median_age
#            total_rooms
#            total_bedrooms
#            population
#            households
#            median_income
#            median_house_value
#            ocean_proximity
#
#        The (continuous) variable "median_house_value" will be used as the
#        response variable for the regression exercises performed by this
#        pipeline. The rest of the variables will be used as predictor
#        variables.
#
#  OUTPUT
#  ======
#  Upon execution, MASTER.py first creates the following output directory:
#  ./output.<username>. When execution finishes without errors, the newly
#  created output directory will contain the following:
#
#    1)  ./output.<username>/MASTER.py
#        a copy of ./MASTER.py (for reproducibility)
#
#    2)  ./output.<username>/code
#        a copy of the code directory ./code (for reproducibility)
#
#    3)  ./output.<username>/log.debug
#        debugging log file (should be empty)
#
#    4)  ./output.<username>/log.stderr
#        standard error log file (should be empty)
#
#    5)  ./output.<username>/log.stdout
#        main output text file of the pipeline.
#        It starts with summary and exploratory statistics of the input file,
#        followed by model-fitting performance metrics of the aforementioned
#        implemented machine learnign techniques.
#
#    6)  ./output.<username>/plot-histograms.png
#        histograms of the nine continuous variables
#
#    7)  ./output.<username>/plot-scatter.png
#        bubble heat map illustrating census block group population sizes and
#        median house values according to geocoordinates
#
#    8)  ./output.<username>/plot-correlations.png
#        correlation matrix for four continuous variables
#
#    9)  ./output.<username>/plot-medianIncome.png
#        scatter plot of median_house_value vs median_income
#
#   10)  ./output.<username>/plot-correlations-02.png
#        correlation matrix involving two existing variables and derived
#        variables
#
################################################################################
################################################################################

import os, sys, shutil, getpass
import pprint, logging, datetime
import stat

# dynamically determine the absolute path of this Python program, and then
# relatively to it, those of the code, data and output folders
thisScript = os.path.realpath(sys.argv[0])
dir_MASTER = os.path.dirname(thisScript)
dir_code   = os.path.join(dir_MASTER, "code")
dir_data   = os.path.join(dir_MASTER, "data")
dir_output = os.path.join(dir_MASTER, "output." + getpass.getuser())

# create the output directory if not already exists
if not os.path.exists(dir_output):
    os.makedirs(dir_output)

# change directory to the output directory
os.chdir(dir_output)

# redirect output and error messages to file
sys.stdout = open('log.stdout','w')
sys.stderr = open('log.stderr','w')

# print system time to output file
myTime = "system time: " + datetime.datetime.now().strftime("%c")
print( "\n" + myTime + "\n" )
print("####################")

logging.basicConfig(filename='log.debug',level=logging.DEBUG)

# create a copy this program (MASTER.py) in output directory (for reproducibility)
shutil.copy2( src = thisScript, dst = dir_output )

# create a copy of code directory in output directory (for reproducibility)
shutil.copytree(src = dir_code, dst = os.path.join(dir_output,"code"))

# append code directory to list of library paths
# (to enable use of Python modules therein)
sys.path.append(dir_code)

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

# import custom-built Python modules
from examineData       import examineData
from splitTrainTest    import splitTrainTest
from visualizeData     import visualizeData
from trainEvaluate     import trainEvaluate
from trainEvaluateGrid import trainEvaluateGrid

from PipelinePreprocessHousingData import PipelinePreprocessHousingData

# import Scikit-learn classes
from sklearn.linear_model import LinearRegression
from sklearn.tree         import DecisionTreeRegressor
from sklearn.ensemble     import RandomForestRegressor

ms_spec = importlib.util.find_spec(name="sklearn.model_selection")
if ms_spec is not None:
    from sklearn.model_selection import GridSearchCV
else:
    from sklearn.grid_search import GridSearchCV

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
# load 1990 California census block group housing data
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
print("\n####################\n")
myTime = "system time: " + datetime.datetime.now().strftime("%c")
print( myTime + "\n" )

