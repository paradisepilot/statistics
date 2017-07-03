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
figFILE = os.path.join(outDIR,'scatter.png')
fig, ax = plt.subplots(1, 1)
ax.scatter(X[   :50,0], X[   :50,1], color = 'red',  marker = 'o', label = 'setosa'    )
ax.scatter(X[50:100,0], X[50:100,1], color = 'blue', marker = 'x', label = 'versicolor')
fig.savefig(figFILE)

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
ppn = Perceptron(eta = 0.1, n_iter = 10)
ppn.fit(X,y)

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
figFILE = os.path.join(outDIR,'error-epoch.png')
fig, ax = plt.subplots(1, 1)
ax.plot(
    range(1,len(ppn.errors_)+1),
    ppn.errors_,
    marker = 'o'
    )
ax.set_xlabel('epoch')
ax.set_ylabel('number of misclassifications')
fig.savefig(figFILE)

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
figFILE = os.path.join(outDIR,'decision-regions.png')
plotDecisionRegions(
    X          = X,
    y          = y,
    classifier = ppn,
    outFILE    = figFILE,
    xlabel     = 'sepal length (cm)',
    ylabel     = 'petal length (cm)'
    )

#################################################
#################################################
sys.exit(0)
#################################################
#################################################

#import numpy as np
#import pandas as pd
#import matplotlib.pyplot as plt
#from mean_sightings import get_sightings

# Set name of data file, table, and figure
dataFILE  = os.path.join(datDIR,'sightings_tab_lg.csv')
tableFILE = os.path.join(outDIR,'spp_table.csv')
figFILE   = os.path.join(outDIR,'spp_fig.png')

# Set names of species to count
spp_names = ['Fox', 'Wolf', 'Grizzly', 'Wolverine']


# ------------------------------------------------------------------------
# Perform analysis 
# ------------------------------------------------------------------------

# Declare empty list to hold counts of records
spp_recs = []

# Get total number of records for each species
for spp in spp_names:
    totalrecs, meancount = get_sightings(dataFILE, spp)
    spp_recs.append(totalrecs)

print('spp_names')
print( spp_names )

print('spp_recs')
print( spp_recs )

print('[spp_names, spp_recs]')
print( [spp_names, spp_recs] )

print('np.transpose([spp_names, spp_recs])')
print( np.transpose([spp_names, spp_recs]) )

# ------------------------------------------------------------------------
# Save results as table 
# ------------------------------------------------------------------------

# Put two lists into a pandas DataFrame
table = pd.DataFrame(
    data    = { 'species' : spp_names, 'recs' : spp_recs },
    columns = ['species','recs']
    )

table.recs = table.recs.astype(str)

print('table')
print( table )

print('table.dtypes')
print( table.dtypes )

# Save DataFrame as csv
table.to_csv(tableFILE,index=False)

# -----------------------------------------------------------------------
# Save results as figure 
# -----------------------------------------------------------------------

# Set up figure with one axis
fig, ax = plt.subplots(1, 1)

# Create bar chart: args are location of left edge, height, and width of bar
ax.bar([0,1,2,3], spp_recs, 0.8)

# Place tick marks in center of each bar
ax.set_xticks([0.4, 1.4, 2.4, 3.4])

# Set limits to give some white space on either side of first/last bar 
ax.set_xlim([-0.2, 4])

# Add species names to x axis
ax.set_xticklabels(spp_names)

# Save figure
fig.savefig(figFILE)

