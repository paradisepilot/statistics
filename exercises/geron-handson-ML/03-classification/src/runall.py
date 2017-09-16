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
from getMNIST       import getMNIST
from visualizeData  import visualizeData
from splitTrainTest import splitTrainTest

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
visualizeData(data = mnist["data"], outputFILE = 'myDigit-full.png')

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

print('\nmnistTrain.describe()')
print(   mnistTrain.describe() )

# visualize data
visualizeData(data = mnistTrain, outputFILE = 'myDigit-train.png')

#################################################
#################################################
print("\n####################\n")
myTime = "system time: " + datetime.datetime.now().strftime("%c")
print( myTime + "\n" )

