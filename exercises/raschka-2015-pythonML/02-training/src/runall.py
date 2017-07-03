#!/usr/bin/env python

import os, stat, sys

thisScript = sys.argv[0]
srcDIR     = sys.argv[1]
datDIR     = sys.argv[2]
outDIR     = sys.argv[3]

# append module path with srcDIR
sys.path.append(srcDIR)

#################################################
#################################################
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from   Perceptron import Perceptron
from   AdalineGD  import AdalineGD 
from   plotFunctions import plotDecisionRegions

# ------------------------------------------------------------------------
# Declare variables
# ------------------------------------------------------------------------
irisFILE = os.path.join(datDIR,'iris.data')
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
figFILE = os.path.join(outDIR,'iris-scatter.png')
fig, ax = plt.subplots(1, 1)
ax.scatter(X[   :50,0], X[   :50,1], color = 'red',  marker = 'o', label = 'setosa'    )
ax.scatter(X[50:100,0], X[50:100,1], color = 'blue', marker = 'x', label = 'versicolor')
fig.savefig(figFILE)

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
ppn = Perceptron(eta = 0.1, n_iter = 10)
ppn.fit(X,y)

figFILE = os.path.join(outDIR,'perceptron-error-epoch.png')
fig, ax = plt.subplots(1, 1)
ax.plot(
    range(1,len(ppn.errors_)+1),
    ppn.errors_,
    marker = 'o'
    )
ax.set_xlabel('epoch')
ax.set_ylabel('number of misclassifications')
fig.savefig(figFILE)

figFILE = os.path.join(outDIR,'decision-regions.png')
plotDecisionRegions(
    X          = X,
    y          = y,
    classifier = ppn,
    outFILE    = figFILE,
    xlabel     = 'sepal length (cm)',
    ylabel     = 'petal length (cm)'
    )

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
fig, ax = plt.subplots(nrows = 1, ncols = 2, figsize = (8,4))

ada0 = AdalineGD(eta = 0.01, n_iter = 10).fit(X,y)
ax[0].plot(
    range(1,len(ada0.cost_)+1),
    np.log10(ada0.cost_),
    marker = 'o'
    )
ax[0].set_xlabel('epoch')
ax[0].set_ylabel('log(sum of squared errors)')
ax[0].set_title('Adaline - Learning rate 0.01')

ada1 = AdalineGD(eta = 0.0001, n_iter = 10).fit(X,y)
ax[1].plot(
    range(1,len(ada1.cost_)+1),
    ada1.cost_,
    marker = 'o'
    )
ax[1].set_xlabel('epoch')
ax[1].set_ylabel('sum of squared errors')
ax[1].set_title('Adaline - Learning rate 0.0001')

figFILE = os.path.join(outDIR,'adaline-error-epoch.png')
fig.savefig(figFILE)

#################################################
#################################################
sys.exit(0)

