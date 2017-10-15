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
# Creating your first graph and
# running it in a session
from firstGraph import firstGraph
firstGraph()

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
# Managing graphs
from manageGraphs import manageGraphs
manageGraphs()

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
# Lifecycle of a node value
from nodeValueLifecycle import nodeValueLifecycle
nodeValueLifecycle()

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
# loading california housing data
from getCaliforniaHousingData import getCaliforniaHousingData
housingData, housingTarget = getCaliforniaHousingData(
    housingFILE = os.path.join(datDIR,"housing.pickle")
    )

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
# Linear regression with TensorFlow
from linearRegressionTF import linearRegressionTF
linearRegressionTF(
    housingData   = housingData,
    housingTarget = housingTarget
    )

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
# manual Gradient Descent
from gradientDescentManual import gradientDescentManual
gradientDescentManual(
    housingData   = housingData,
    housingTarget = housingTarget,
    nEpochs       = 5000,
    learningRate  = 0.01,
    pageSize      = 500
    )

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
# Gradient Descent with Autodiff
from gradientDescentAutodiff import gradientDescentAutodiff
gradientDescentAutodiff(
    housingData   = housingData,
    housingTarget = housingTarget,
    nEpochs       = 5000,
    learningRate  = 0.01,
    pageSize      = 500
    )

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
# Gradient Descent using an optimizer
from gradientDescentOptimizer import gradientDescentOptimizer
gradientDescentOptimizer(
    housingData   = housingData,
    housingTarget = housingTarget,
    nEpochs       = 5000,
    learningRate  = 0.01,
    pageSize      = 500
    )

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
# Mini-batch Gradient Descent using TensorFlow.placeholder()
from gradientDescentMiniBatch import gradientDescentMiniBatch
gradientDescentMiniBatch(
    housingData   = housingData,
    housingTarget = housingTarget,
    nEpochs       = 100,
    learningRate  = 0.01,
    pageSize      = 10,
    logFrequency  = 10,
    outDIR        = outDIR
    )

#################################################
#################################################
print("\n####################\n")
myTime = "system time: " + datetime.datetime.now().strftime("%c")
print( myTime + "\n" )

