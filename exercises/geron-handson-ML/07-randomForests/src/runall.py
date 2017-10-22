#!/usr/bin/env python

import os, getpass, shutil, stat, sys, time, pprint, logging, datetime

thisScript = sys.argv[0]
srcDIR     = sys.argv[1]
datDIR     = sys.argv[2]
outDIR     = sys.argv[3]

# create outDIR if not yet exists
if not os.path.exists(outDIR):
    os.makedirs(outDIR)

# change directory to outDIR
os.chdir(outDIR)

# copy srcDIR to srcCOPY
srcCOPY = os.path.join(outDIR,"src")
shutil.copytree(src = srcDIR, dst = srcCOPY)

# append module path with srcCOPY
sys.path.append(srcCOPY)

# print system time
myTime = "system time: " + datetime.datetime.now().strftime("%c")
print( "\n" + myTime + "\n" )
print("####################")

#################################################
#################################################

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
# loading iris data
from getIrisData import getIrisData, examineIrisData
irisData = getIrisData(
    irisFILE = os.path.join(datDIR,"iris.pickle")
    )

examineIrisData(irisData = irisData)

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
# splitting iris data into training and testing subsets
from splitIrisData import splitIrisData
X_train, y_train, X_test, y_test = splitIrisData(
    irisData    = irisData,
    testSize    = 0.2,
    randomState = 1234567
    )

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
from votingClassifier import votingClassifier
votingClassifier(
    X_train = X_train,
    y_train = y_train,
    X_test  = X_test,
    y_test  = y_test
    )

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
from baggedDecisionTree import baggedDecisionTree
baggedDecisionTree(
    nEstimators = 500,
    X_train     = X_train,
    y_train     = y_train,
    X_test      = X_test,
    y_test      = y_test
    )

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
from randomForest import randomForest
randomForest(
    nEstimators  = 500,
    maxLeafNodes = 16,
    irisData     = irisData,
    X_train      = X_train,
    y_train      = y_train,
    X_test       = X_test,
    y_test       = y_test
    )

#################################################
#################################################
print("\n####################\n")
myTime = "system time: " + datetime.datetime.now().strftime("%c")
print( myTime + "\n" )

