#!/usr/bin/env python
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
print( myTime )

logging.basicConfig(filename='log.debug',level=logging.DEBUG)

shutil.copy2( src = thisScript, dst = dir_output )
shutil.copytree(src = dir_code, dst = os.path.join(dir_output,"code"))

# append code directory to list of library paths
sys.path.append(dir_code)

print('\nthisScript')
print(   thisScript )

print('\ndir_code')
print(   dir_code )

print('\ndir_output')
print(   dir_output )

##################################################
##################################################
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
from sklearn.ensemble        import RandomForestRegressor
from sklearn.model_selection import cross_val_score, GridSearchCV
from sklearn.preprocessing   import LabelEncoder

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
# load data
housingFILE = os.path.join(dir_data,'housing.csv')
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
# evaluate linear model via 10-fold cross-validation
linearModelCVScores = cross_val_score(
    estimator = linearModel,
    X         = preprocessedStratTrainSet,
    y         = stratifiedTrainSet["median_house_value"],
    scoring   = "neg_mean_squared_error",
    cv        = 10
    )
linearModelCVRMSE = np.sqrt( - linearModelCVScores )

print("\nlinearModelCVRMSE")
print(   linearModelCVRMSE )

print("\nlinearModelCVRMSE.mean()")
print(   linearModelCVRMSE.mean() )

print("\nlinearModelCVRMSE.std()")
print(   linearModelCVRMSE.std() )

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
# evaluate regression tree via 10-fold cross-validation
regressionTreeCVScores = cross_val_score(
    estimator = regressionTreeModel,
    X         = preprocessedStratTrainSet,
    y         = stratifiedTrainSet["median_house_value"],
    scoring   = "neg_mean_squared_error",
    cv        = 10
    )
regressionTreeCVRMSE = np.sqrt( - regressionTreeCVScores )

print("\nregressionTreeCVRMSE")
print(   regressionTreeCVRMSE )

print("\nregressionTreeCVRMSE.mean()")
print(   regressionTreeCVRMSE.mean() )

print("\nregressionTreeCVRMSE.std()")
print(   regressionTreeCVRMSE.std() )

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
# random forest
randomForestModel = RandomForestRegressor()
randomForestModel.fit(X = preprocessedStratTrainSet, y = stratifiedTrainSet["median_house_value"])

predictedHouseValues = randomForestModel.predict(X = preprocessedStratTrainSet)
randomForestMSE      = mean_squared_error(predictedHouseValues,stratifiedTrainSet["median_house_value"])
randomForestRMSE     = np.sqrt(randomForestMSE)

print("\nrandomForestRMSE")
print(   randomForestRMSE )

# evaluate random forest with 10-fold cross-validation
randomForestCVScores = cross_val_score(
    estimator = randomForestModel,
    X         = preprocessedStratTrainSet,
    y         = stratifiedTrainSet["median_house_value"],
    scoring   = "neg_mean_squared_error",
    cv        = 10
    )
randomForestCVRMSE = np.sqrt( - randomForestCVScores )

print("\nrandomForestCVRMSE")
print(   randomForestCVRMSE )

print("\nrandomForestCVRMSE.mean()")
print(   randomForestCVRMSE.mean() )

print("\nrandomForestCVRMSE.std()")
print(   randomForestCVRMSE.std() )

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
# random forest with hyperparameter tuning via grid search
newRandomForestModel = RandomForestRegressor()

parameterGrid = [
    { 'n_estimators':[3,10,30], 'max_features':[2,4,6,8]                     },
    { 'n_estimators':[3,10],    'max_features':[2,3,4],  'bootstrap':[False] }
    ]

gridSearch = GridSearchCV(
    estimator = newRandomForestModel,
    param_grid = parameterGrid,
    scoring = "neg_mean_squared_error",
    cv = 5
    )

gridSearch.fit(X = preprocessedStratTrainSet, y = stratifiedTrainSet["median_house_value"])

print("\ngridSearch.best_params_")
print(   gridSearch.best_params_ )

print("\ngridSearch.best_estimator_")
print(   gridSearch.best_estimator_ )

CVResults = gridSearch.cv_results_
for mean_score, params in zip(CVResults["mean_test_score"], CVResults["params"]):
    print( np.sqrt(-mean_score) , params )

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
# examine feature importances
featureImportances = gridSearch.best_estimator_.feature_importances_
print("\nfeatureImportances")
print(   featureImportances )

numericAttribs = list(stratifiedTrainSet.drop(["ocean_proximity"],axis=1).columns)

oneHotEncoder     = LabelEncoder()
housingCatEncoded = oneHotEncoder.fit(stratifiedTrainSet["ocean_proximity"])
oneHotAttribs     = oneHotEncoder.classes_

extraAttribs = ["roomsPerHhold", "popPerHhold", "bedroomsPerRoom"]
attributes = list(numericAttribs) + extraAttribs + list(oneHotAttribs)

print("\nnumericAttribs")
print(   numericAttribs )

print("\noneHotAttribs")
print(   oneHotAttribs )

print("\nattributes")
print(   attributes )

print("\nsorted(zip(featureImportances,attributes),reverse=True)")
print(   sorted(zip(featureImportances,attributes),reverse=True) )

##################################################
##################################################
myTime = "system time: " + datetime.datetime.now().strftime("%c")
print( myTime )

