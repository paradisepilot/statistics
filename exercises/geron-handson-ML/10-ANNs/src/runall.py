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
# The Perceptron

# loading iris data
from getIrisData import getIrisData, examineIrisData
irisData = getIrisData(
    irisFILE = os.path.join(datDIR,"iris.pickle")
    )

examineIrisData(irisData = irisData)

from thePerceptron import thePerceptron
thePerceptron(irisData = irisData)

# splitting iris data into training and testing subsets
#from splitIrisData import splitIrisData
#X_train, y_train, X_test, y_test = splitIrisData(
#    irisData    = irisData,
#    testSize    = 0.2,
#    randomState = 1234567
#    )

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
# training Multi-Layer Perceptron with
# high-level API

# load MNIST data
from getMNIST import getMNIST
mnistData = getMNIST( mnistFILE = os.path.join(datDIR,"mnist.pickle") )

# split MNIST data into training and testing sets
from splitMNIST import splitMNIST
mnistTrain, mnistTest = splitMNIST(data = mnistData, random_state = 1234567)

# training
#from trainMLPviaAPI import trainMLPviaAPI
#trainMLPviaAPI(
#    mnistTrain = mnistTrain,
#    mnistTest  = mnistTest
#    )

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
# training a DNN with plain TensorFlow
from trainDNNviaPlainTF import trainDNNviaPlainTF
trainDNNviaPlainTF( mnistFILE = os.path.join(datDIR,"tfMNIST.pickle") )

#################################################
#################################################
print("\n####################\n")
myTime = "system time: " + datetime.datetime.now().strftime("%c")
print( myTime + "\n" )

