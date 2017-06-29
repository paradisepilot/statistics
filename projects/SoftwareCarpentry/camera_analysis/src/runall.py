#!/usr/bin/env python

'''
Script to create all results for camera_analysis project.
'''

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from mean_sightings import get_sightings


# ------------------------------------------------------------------------
# Declare variables
# ------------------------------------------------------------------------

# Set paths to data and results directories. Note that this method of
# relative paths only works on *nix - for Windows, see os.path module.
data_dir = '../data/'
results_dir = '../results/'

# Set name of data file, table, and figure
data_name = 'sightings_tab_lg.csv'
table_name = 'spp_table.csv'
fig_name = 'spp_fig.png'

# Set names of species to count
spp_names = ['Fox', 'Wolf', 'Grizzly', 'Wolverine']


# ------------------------------------------------------------------------
# Perform analysis 
# ------------------------------------------------------------------------

# Declare empty list to hold counts of records
spp_recs = []

# Get total number of records for each species
for spp in spp_names:
    totalrecs, meancount = get_sightings(data_dir + data_name, spp)
    spp_recs.append(totalrecs)

print spp_names
print spp_recs
