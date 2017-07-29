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
import matplotlib.pyplot as plt

from sklearn.model_selection import train_test_split
from sklearn.preprocessing   import StandardScaler
from sklearn.linear_model    import Perceptron
from sklearn.metrics         import accuracy_score

from examineData    import examineData
from splitTrainTest import splitTrainTest

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
housingFILE = os.path.join(datDIR,'housing.csv')
housingDF   = pd.read_csv(housingFILE);

examineData(inputDF = housingDF);
stratifiedTrainSet, stratifiedTestSet = splitTrainTest(inputDF = housingDF)

#################################################
#################################################

sys.exit(0)

