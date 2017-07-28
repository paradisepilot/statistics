#!/usr/bin/env python
import os, sys, shutil, getpass
import pprint, logging, datetime
import stat

thisScript = sys.argv[0]
dir_MASTER = os.path.dirname(os.path.realpath(sys.argv[0]))
dir_code   = os.path.join(dir_MASTER, "code")
dir_data   = os.path.join(dir_MASTER, "data")
dir_output = os.path.join(dir_MASTER, "output." + getpass.getuser())

if not os.path.exists(dir_output):
    os.makedirs(dir_output)

os.chdir(dir_output)
sys.stdout = open('log.stdout','w')
myTime = "system time: " + datetime.datetime.now().strftime("%c")
print( myTime )

logging.basicConfig(filename='log.debug',level=logging.DEBUG)

shutil.copy2( src = os.path.join(dir_MASTER,thisScript), dst = dir_output )
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
import numpy   as np
import pandas  as pd
import seaborn as sns
import matplotlib.pyplot as plt

from Perceptron    import Perceptron
from AdalineGD     import AdalineGD
from AdalineSGD    import AdalineSGD
from plotFunctions import plotDecisionRegions

# ------------------------------------------------------------------------
# Declare variables
# ------------------------------------------------------------------------
irisFILE = os.path.join(dir_data,'iris.data')
irisDF   = pd.read_csv(irisFILE, header=None);

irisDF.columns = [
    'sepal_length',
    'sepal_width',
    'petal_length',
    'petal_width',
    'class'
    ]

irisDF["class"] = irisDF["class"].astype('category')

print('\nirisDF.tail()')
print(   irisDF.tail() )

print('\nirisDF.describe()')
print(   irisDF.describe() )

print('\nirisDF["class"].value_counts()')
print(   irisDF["class"].value_counts() )

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
X = irisDF.iloc[0:100,[0,2]].values
y = irisDF.iloc[0:100,    4].values
y = np.where(y == 'Iris-setosa',-1,1);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
figFILE = os.path.join(dir_output,'iris-scatter.png')
fig, ax = plt.subplots(1, 1)
ax.scatter(X[   :50,0], X[   :50,1], color = 'red',  marker = 'o', label = 'setosa'    )
ax.scatter(X[50:100,0], X[50:100,1], color = 'blue', marker = 'x', label = 'versicolor')
fig.savefig(figFILE)

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
ppn = Perceptron(eta = 0.1, n_iter = 10)
ppn.fit(X,y)

figFILE = os.path.join(dir_output,'perceptron-error-epoch.png')
fig, ax = plt.subplots(1, 1)
ax.plot(
    range(1,len(ppn.errors_)+1),
    ppn.errors_,
    marker = 'o'
    )
ax.set_xlabel('epoch')
ax.set_ylabel('number of misclassifications')
fig.savefig(figFILE)

figFILE = os.path.join(dir_output,'decision-regions.png')
plotDecisionRegions(
    X          = X,
    y          = y,
    classifier = ppn,
    outFILE    = figFILE,
    title      = 'Perceptron',
    xlabel     = 'sepal length (cm)',
    ylabel     = 'petal length (cm)'
    )

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
figFILE = os.path.join(dir_output,'adaline-error-epoch.png')
fig, ax = plt.subplots(nrows = 1, ncols = 2, figsize = (8,4))

ada0 = AdalineGD(eta = 0.01, n_iter = 20).fit(X,y)
ax[0].plot(
    range(1,len(ada0.cost_)+1),
    np.log10(ada0.cost_),
    marker = 'o'
    )
ax[0].set_xlabel('epoch')
ax[0].set_ylabel('log(sum of squared errors)')
ax[0].set_title('Adaline - Learning rate 0.01')

ada1 = AdalineGD(eta = 0.0001, n_iter = 20).fit(X,y)
ax[1].plot(
    range(1,len(ada1.cost_)+1),
    ada1.cost_,
    marker = 'o'
    )
ax[1].set_xlabel('epoch')
ax[1].set_ylabel('sum of squared errors')
ax[1].set_title('Adaline - Learning rate 0.0001')

fig.savefig(figFILE)

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
X_std = np.copy(X)
X_std[:,0] = (X_std[:,0] - X_std[:,0].mean()) / X[:,0].std()
X_std[:,1] = (X_std[:,1] - X_std[:,1].mean()) / X[:,1].std()

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
ada = AdalineGD(n_iter = 20, eta = 0.01)
ada.fit(X_std,y)

figFILE = os.path.join(dir_output,'adaline-STD-decision-regions.png')
plotDecisionRegions(
    X          = X_std,
    y          = y,
    classifier = ada,
    outFILE    = figFILE,
    title      = 'Adaline GD',
    xlabel     = 'sepal length (standardized)',
    ylabel     = 'petal length (standardized)'
    )

figFILE = os.path.join(dir_output,'adaline-STD-error-epoch.png')
fig, ax = plt.subplots(nrows = 1, ncols = 1, figsize = (8,4))
ax.plot(
    range(1,len(ada.cost_)+1),
    ada.cost_,
    marker = 'o'
    )
ax.set_xlabel('epoch')
ax.set_ylabel('sum of squared errors')
ax.set_title('Adaline - Learning rate 0.01')

fig.savefig(figFILE)

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
ada = AdalineSGD(n_iter = 20, eta = 0.01, random_state = 1)
ada.fit(X_std,y)

figFILE = os.path.join(dir_output,'adalineSGD-STD-decision-regions.png')
plotDecisionRegions(
    X          = X_std,
    y          = y,
    classifier = ada,
    outFILE    = figFILE,
    title      = 'Adaline SGD',
    xlabel     = 'sepal length (standardized)',
    ylabel     = 'petal length (standardized)'
    )

figFILE = os.path.join(dir_output,'adalineSGD-STD-error-epoch.png')
fig, ax = plt.subplots(nrows = 1, ncols = 1, figsize = (8,4))
ax.plot(
    range(1,len(ada.cost_)+1),
    ada.cost_,
    marker = 'o'
    )
ax.set_xlabel('epoch')
ax.set_ylabel('average cost')
ax.set_title('Adaline SGD - Learning rate 0.01')

fig.savefig(figFILE)

##################################################
##################################################

pprint.pprint(sys.modules)

myTime = "system time: " + datetime.datetime.now().strftime("%c")
print( myTime )

