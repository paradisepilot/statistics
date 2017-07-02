#!/usr/bin/env python

import os, stat, sys

thisScript = sys.argv[0]
srcDIR     = sys.argv[1]
datDIR     = sys.argv[2]
outDIR     = sys.argv[3]

print('thisScript')
print( thisScript )

print('srcDIR')
print( srcDIR )

print('datDIR')
print( datDIR )

print('outDIR')
print( outDIR )

# append module path with srcDIR
sys.path.append(srcDIR)

# set permissions on outDIR
#os.chmod(outDIR,stat.S_IRWXU)
#os.chmod(outDIR,stat.S_IRWXG)
# change current working directory to outDIR
#os.chdir(outDIR)

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
# sys.exit(0)

'''
Script to create all results for camera_analysis project.
'''

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import Perceptron

# ------------------------------------------------------------------------
# Declare variables
# ------------------------------------------------------------------------
irisFILE = os.path.join(datDIR,'iris.data')
irisDF   = pd.read_csv(irisFILE, header=None);

print('irisDF.tail()')
print( irisDF.tail() )

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
sys.exit(0)
### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###

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

