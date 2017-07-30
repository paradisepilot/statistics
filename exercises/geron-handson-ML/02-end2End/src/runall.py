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
import pandas  as pd
import seaborn as sns

from scipy import stats

from examineData    import examineData
from splitTrainTest import splitTrainTest
from visualizeData  import visualizeData

from PipelinePreprocessHousingData import PipelinePreprocessHousingData

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

print("\nstratifiedTrainSet.describe()")
print(   stratifiedTrainSet.describe() )

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
# preprocess stratified training data set
preprocessedStratTrainSet = PipelinePreprocessHousingData.fit_transform(stratifiedTrainSet)

print("\npreprocessedStratTrainSet.shape")
print(   preprocessedStratTrainSet.shape )

print("\nstats.describe(preprocessedStratTrainSet)")
print(   stats.describe(preprocessedStratTrainSet) )

#################################################
#################################################

sys.exit(0)

