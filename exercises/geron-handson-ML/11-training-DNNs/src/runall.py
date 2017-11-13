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
### load MNIST data from TensorFlow
from tfGetMNIST import tfGetMNIST
mnistData = tfGetMNIST(
    mnistFILE = os.path.join(datDIR,"tfMNIST.pickle")
    )

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### training a DNN with plain TensorFlow
#from trainDNNviaPlainTF import trainDNNviaPlainTF
#trainDNNviaPlainTF(
#    mnistData      = mnistData,
#    checkpointPATH = os.path.join(datDIR,"my_model_final.ckpt"),
#    nHidden1       = 10,
#    nHidden2       = 10,
#    learningRate   = 0.01,
#    nEpochs        = 40,
#    batchSize      = 50
#    )

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### training a DNN with plain TensorFlow
from fiveHiddenLayers import fiveHiddenLayers
fiveHiddenLayers(
    mnistData      = mnistData,
    checkpointPATH = os.path.join(datDIR,"fiveHiddenLayers.ckpt"),
    nInputs        = 28 * 28,
    nOutputs       = 10,
    nHidden1       = 10,
    nHidden2       = 10,
    nHidden3       = 10,
    nHidden4       = 10,
    nHidden5       = 10,
    learningRate   = 0.01,
    nEpochs        = 40,
    batchSize      = 50
    )

#################################################
#################################################
print("\n####################\n")
myTime = "system time: " + datetime.datetime.now().strftime("%c")
print( myTime + "\n" )

