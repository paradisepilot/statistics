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
import numpy   as np
import pandas  as pd
import seaborn as sns
import matplotlib.pyplot as plt

from sklearn.model_selection import train_test_split
from sklearn.preprocessing   import StandardScaler
from sklearn.linear_model    import Perceptron
from sklearn.metrics         import accuracy_score

from plotFunctions import plotDecisionRegions

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
# irisFILE = os.path.join(datDIR,'iris.data')
# irisDF   = pd.read_csv(irisFILE, header=None);

from sklearn import datasets
irisDATA = datasets.load_iris()

irisDF = pd.concat(
    [pd.DataFrame(irisDATA.data),pd.DataFrame(irisDATA.target)],
    axis=1
    )

irisDF.columns = [
    'sepal_length',
    'sepal_width',
    'petal_length',
    'petal_width',
    'class'
    ]

#irisDF["class"] = irisDF["class"].astype('category')

print('\nirisDF.tail()')
print(   irisDF.tail() )

print('\nirisDF.describe()')
print(   irisDF.describe() )

print('\nirisDF["class"].value_counts()')
print(   irisDF["class"].value_counts() )

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
X = irisDF.iloc[:,[2,3]].values
y = irisDF.iloc[:,    4].values

print('type(X)')
print( type(X) )

print('type(y)')
print( type(y) )

X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size = 0.3, random_state = 0
    )

print('X_train.shape')
print( X_train.shape )

print('X_train.shape[0]')
print( X_train.shape[0] )

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
sc = StandardScaler()
sc.fit(X_train)
X_train_std = sc.transform(X_train)
X_test_std  = sc.transform(X_test)

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
ppn = Perceptron(n_iter = 40, eta0 = 0.1, random_state = 0)
ppn.fit(X_train_std,y_train)

y_pred = ppn.predict(X_test_std)
print('Misclassified test observations: %d' % (y_test != y_pred).sum())

print('Accuracy: %.2f' % accuracy_score(y_test,y_pred))

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
X_combined_std = np.vstack((X_train_std,X_test_std))
y_combined     = np.hstack((y_train,    y_test    ))

print('X_combined_std.shape[0]')
print( X_combined_std.shape[0] )

pngFILE = os.path.join(outDIR,'width-vs-length.png')
plotDecisionRegions(
    X          = X_combined_std,
    y          = y_combined,
    classifier = ppn,
    test_idx   = range(X_train.shape[0],X_combined_std.shape[0]),
    outFILE    = pngFILE,
    title      = 'Perceptron decision regions',
    xlabel     = 'petal length (standardized)',
    ylabel     = 'petal width (standardized)'
    )

#################################################
#################################################

sys.exit(0)

