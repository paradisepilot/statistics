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
# import seaborn (for improved graphics) if available
import seaborn as sns

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
from getMNIST             import getMNIST
from NeverFiveClassifier  import NeverFiveClassifier
from sklearn.ensemble     import RandomForestClassifier
from sklearn.linear_model import SGDClassifier
from splitTrainTest       import splitTrainTest
from trainEvaluateBinary  import trainEvaluateBinary
from visualizeData        import visualizeData

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
# load data
mnist = getMNIST( mnistFILE = os.path.join(datDIR,"mnist.pickle") )

print('\ntype(mnist)')
print(   type(mnist) )

print('\nmnist')
print(   mnist )

print('\ntype(mnist["data"])')
print(   type(mnist["data"]) )

print('\nmnist["data"].shape')
print(   mnist["data"].shape )

print('\nmnist["data"]')
print(   mnist["data"] )

print('\ntype(mnist["target"])')
print(   type(mnist["target"]) )

print('\nmnist["target"].shape')
print(   mnist["target"].shape )

print('\nmnist["target"]')
print(   mnist["target"] )

# visualize data
myIndex = 36000;
visualizeData(data = mnist["data"], index = myIndex, outputFILE = 'digit-full-' + str(myIndex) + '.png')

# split data into training and testing sets
mnistTrain, mnistTest = splitTrainTest(data = mnist, random_state = 1234567)

print('\ntype(mnistTrain)')
print(   type(mnistTrain) )

print('\nmnistTrain.shape')
print(   mnistTrain.shape )

print('\ntype(mnistTest)')
print(   type(mnistTest) )

print('\nmnistTest.shape')
print(   mnistTest.shape )

#print('\nmnistTrain.describe()')
#print(   mnistTrain.describe() )

print('\nmnistTrain.columns')
print(   mnistTrain.columns )

# visualize data
myIndex = 10000;
visualizeData(data = mnistTrain, index = myIndex, outputFILE = 'digit-train-' + str(myIndex) + '.png')

myIndex = 20000;
visualizeData(data = mnistTrain, index = myIndex, outputFILE = 'digit-train-' + str(myIndex) + '.png')

myIndex = 30000;
visualizeData(data = mnistTrain, index = myIndex, outputFILE = 'digit-train-' + str(myIndex) + '.png')

myIndex = 40000;
visualizeData(data = mnistTrain, index = myIndex, outputFILE = 'digit-train-' + str(myIndex) + '.png')

myIndex = 50000;
visualizeData(data = mnistTrain, index = myIndex, outputFILE = 'digit-train-' + str(myIndex) + '.png')

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
mySGDClassifier = SGDClassifier(random_state = 42)
trainEvaluateBinary(
    trainData = mnistTrain,
    testData  = mnistTest,
    myModel   = mySGDClassifier,
    modelName = 'SGDClassifier'
    )

myNeverFiveClassifier = NeverFiveClassifier()
trainEvaluateBinary(
    trainData = mnistTrain,
    testData  = mnistTest,
    myModel   = myNeverFiveClassifier,
    modelName = 'NeverFiveClassifier'
    )

myRFClassifier = RandomForestClassifier(random_state = 42)
trainEvaluateBinary(
    trainData = mnistTrain,
    testData  = mnistTest,
    myModel   = myRFClassifier,
    modelName = 'RandomForestClassifier'
    )

#################################################
#################################################
print("\n####################\n")
myTime = "system time: " + datetime.datetime.now().strftime("%c")
print( myTime + "\n" )

