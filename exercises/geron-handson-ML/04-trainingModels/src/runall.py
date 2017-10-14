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
import seaborn
import numpy as np

from getData import getDataLinear
from getData import getDataQuadratic

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
# Generate synthetic data
X,y = getDataLinear(nobs=100,seed=12345)

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
# Perform linear regression using the normal equation
from normalEquation import normalEquation
normalEquation(X,y)

np.random.seed(seed=12345)
theta0 = np.random.randn(1,2)

# Perform linear regression using Batch Gradient Descent
from batchGradientDescent import batchGradientDescent
batchGradientDescent(X,y,theta0)

# Perform linear regression using Stochastic Gradient Descent
from stochasticGradientDescent import stochasticGradientDescent
stochasticGradientDescent(X,y,theta0)

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###

# Perform linear regression using Stochastic Gradient Descent
from polynomialRegression import polynomialRegression
X,y = getDataQuadratic(nobs=200,seed=12345)
polynomialRegression(X,y)

# Learning curves
from learningCurves import learningCurves
X,y = getDataQuadratic(nobs=100,seed=19)
learningCurves(X,y)

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
X,y = getDataLinear(nobs=35,seed=12345)

# Ridge regression
from ridgeRegression import ridgeRegression
ridgeRegression(X,y)

# Lasso regression
from lassoRegression import lassoRegression
lassoRegression(X,y)

# Elastic Net
from elasticNet import elasticNet
elasticNet(X,y)

#################################################
#################################################
print("\n####################\n")
myTime = "system time: " + datetime.datetime.now().strftime("%c")
print( myTime + "\n" )

